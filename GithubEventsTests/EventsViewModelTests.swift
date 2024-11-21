import XCTest
import Combine
@testable import GithubEvents

final class EventsViewModelTests: XCTestCase {
    private var cancellables: Set<AnyCancellable>!
    private var viewModel: EventsViewModelProtocol!
    private var router: MockEventsRouter!
    private let eventService = MockEventsService()
    
    private let mockEvents: [Event] = [
        Event(
            id: "0",
            type: .forkEvent,
            actor: Actor(id: 0, login: "actor1", url: URL(string: "http://actor1.com")!, avatarUrl: URL(string: "http://actor1.com/avatar.png")!),
            repo: Repo.init(id: 0, url: URL(string: "http://repo1.com")!, name: "repo1")
        ),
        Event(
            id: "1",
            type: .pushEvent,
            actor: Actor(id: 0, login: "actor2", url: URL(string: "http://actor2.com")!, avatarUrl: URL(string: "http://actor2.com/avatar.png")!),
            repo: Repo.init(id: 0, url: URL(string: "http://repo2.com")!, name: "repo1")
        ),
        Event(
            id: "2",
            type: .unknown,
            actor: Actor(id: 0, login: "actor2", url: URL(string: "http://actor2.com")!, avatarUrl: URL(string: "http://actor2.com/avatar.png")!),
            repo: Repo.init(id: 0, url: URL(string: "http://repo2.com")!, name: "repo1")
        )
    ]
    
    let mockError = NSError(domain: "com.example.error", code: 404, userInfo: [NSLocalizedDescriptionKey: "Mocked Error"])

    override func setUpWithError() throws {
        try super.setUpWithError()
        cancellables = []
        setupViewModel()
    }

    override func tearDownWithError() throws {
        try super.tearDownWithError()
        cancellables.removeAll()
    }

    private func setupViewModel() {
        router = MockEventsRouter()
        viewModel = EventsViewModel(
            eventService: eventService,
            eventsRouter: router
        )
    }
    
    func testEventsFetched() throws {
        let expectation = expectation(description: "Events fetched")
        eventService.mockRequest = Just(mockEvents)
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
        
        viewModel
            .eventsSubject
            .sink { [weak self] cellViewModels in
                guard let self else { return }
                cellViewModels.enumerated().forEach { index in
                    let model = index.element
                    let event = self.mockEvents[index.offset]
                    XCTAssertEqual(model.id, event.id)
                }
                XCTAssertTrue(Thread.isMainThread, "Publisher did not deliver data on the main thread")
                expectation.fulfill()
            }
            .store(in: &cancellables)
        
        viewModel.fetchEvents()
        
        waitForExpectations(timeout: 5)
    }
    
    func testRouteToErrorWhenEventServiceFailed() {
        let expectation = expectation(description: "Event service failed")
        eventService.mockRequest = Fail<[Event], Error>(error: mockError)
            .eraseToAnyPublisher()
        
        router.routeToErrorCall = { errorMessage in
            XCTAssertEqual(errorMessage, "Mocked Error")
            XCTAssertTrue(Thread.isMainThread, "Publisher did not deliver data on the main thread")
            expectation.fulfill()
        }
        
        viewModel.fetchEvents()
        
        waitForExpectations(timeout: 5)
    }
    
    func testRouteToEventDetail() throws {
        let expectationFetch = expectation(description: "Events fetched")
        let expectationRoute = expectation(description: "Routed to event detail")
        eventService.mockRequest = Just(mockEvents)
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
        
        viewModel
            .eventsSubject
            .sink { [weak self] cellViewModels in
                guard
                    let self,
                    let model = cellViewModels.first
                else {
                    return
                }
                
                self.viewModel.routeToEventDetail(with: model)
                expectationFetch.fulfill()
            }
            .store(in: &cancellables)
        
        viewModel.fetchEvents()
        
        router.routeToEventDetailCall = { [weak self] event in
            guard let self else { return }
            XCTAssertEqual(event.id, self.mockEvents.first?.id)
            expectationRoute.fulfill()
        }
        
        waitForExpectations(timeout: 5)
    }
    
    func testRouteToFilter() {
        let expectationFilter = expectation(description: "Filter applied")

        eventService.mockRequest = Just(mockEvents)
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()

        viewModel.fetchEvents()

        router.filteredEventTypes = [.pullRequestEvent]
        router.routeToFilterCall = { selectedTypes in
            XCTAssertEqual(selectedTypes, [.pullRequestEvent], "Filtered event types mismatch")
            expectationFilter.fulfill()
        }

        viewModel.routeToFilter()

        waitForExpectations(timeout: 5)
    }
    
    func testAutoRefresh() {
        let expectation = expectation(description: "Auto-refresh triggered")
        expectation.expectedFulfillmentCount = 3

        var callCount = 0

        
        eventService.mockRequest = Just(mockEvents)
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()

        viewModel
            .eventsSubject
            .sink { _ in
                callCount += 1
                if callCount <= 3 {
                    expectation.fulfill()
                }
            }
            .store(in: &cancellables)

        viewModel.startAutoRefresh()

        waitForExpectations(timeout: 35)

        XCTAssertEqual(callCount, 3, "fetchEvents should have been called exactly 3 times")
    }

}
