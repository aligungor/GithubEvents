import GithubEvents

class MockEventsRouter: EventsRouterProtocol {
    var routeToErrorCall: ((String) -> Void)?
    var routeToEventDetailCall: ((Event) -> Void)?
    var routeToFilterCall: EventSelectionHandler?
    var filteredEventTypes: [EventType] = []

    func routeToError(with message: String) {
        routeToErrorCall?(message)
    }

    func routeToEventDetail(with event: Event) {
        routeToEventDetailCall?(event)
    }

    func routeToFilter(eventSelection: @escaping EventSelectionHandler) {
        eventSelection(filteredEventTypes)
        routeToFilterCall?(filteredEventTypes)
    }
}
