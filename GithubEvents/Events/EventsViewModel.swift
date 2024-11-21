import Foundation
import Combine

protocol EventsViewModelProtocol {
    var eventsSubject: PassthroughSubject<[EventCellViewModel], Never> { get }
    func fetchEvents()
    func routeToEventDetail(with eventCellViewModel: EventCellViewModel)
    func routeToFilter()
    func startAutoRefresh()
}

class EventsViewModel: EventsViewModelProtocol {
    private let eventService: EventServiceProtocol
    private let eventsRouter: EventsRouterProtocol
    private var cancellables = Set<AnyCancellable>()
    private var events = [Event]()
    private var selectedEventTypes: [EventType] = EventType.allCases

    let eventsSubject = PassthroughSubject<[EventCellViewModel], Never>()
    private var timer: AnyCancellable?
    
    init(
        eventService: EventServiceProtocol = EventService(),
        eventsRouter: EventsRouterProtocol
    ) {
        self.eventService = eventService
        self.eventsRouter = eventsRouter
    }
    
    func fetchEvents() {
        eventService
            .fetchEvents()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                guard case let .failure(error) = completion else { return }
                self?.eventsRouter.routeToError(with: error.localizedDescription)
            } receiveValue: { [weak self] fetchedEvents in
                guard let self else { return }
                let newEvents = fetchedEvents.filter { newEvent in
                    !self.events.contains(where: { $0.id == newEvent.id })
                }
                self.events.insert(contentsOf: newEvents, at: 0)
                self.updateEventCellViewModels()
            }
            .store(in: &cancellables)
    }
    
    func routeToEventDetail(with eventCellViewModel: EventCellViewModel) {
        guard let event = self.events.first(where: { $0.id == eventCellViewModel.id }) else {
            return
        }
        eventsRouter.routeToEventDetail(with: event)
    }
    
    @objc func routeToFilter() {
        eventsRouter.routeToFilter { [weak self] eventTypes in
            guard let self else { return }
            selectedEventTypes = eventTypes
            updateEventCellViewModels()
        }
    }
    
    private func updateEventCellViewModels() {
        let cellViewModels = events
            .filter { event in
                return selectedEventTypes.contains(event.type)
            }
            .map { EventCellViewModel(event: $0) }
        self.eventsSubject.send(cellViewModels)
    }
    
    func startAutoRefresh() {
        timer = Timer
            .publish(every: 10, on: .main, in: .common)
            .autoconnect()
            .sink { [weak self] _ in
                self?.fetchEvents()
            }
    }
    
    deinit {
        timer?.cancel()
    }
}
