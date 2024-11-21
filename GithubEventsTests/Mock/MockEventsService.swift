import Combine
import GithubEvents

class MockEventsService: EventServiceProtocol {
    var mockRequest: AnyPublisher<[Event], Error>!
    
    func fetchEvents() -> AnyPublisher<[Event], Error> {
        return mockRequest
    }
}
