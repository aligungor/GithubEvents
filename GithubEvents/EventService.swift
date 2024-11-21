import Foundation
import Combine

public protocol EventServiceProtocol {
    func fetchEvents() -> AnyPublisher<[Event], Error>
}

class EventService: EventServiceProtocol {
    private let url = URL(string: "https://api.github.com/events")!
    
    func fetchEvents() -> AnyPublisher<[Event], Error> {
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue("application/vnd.github+json", forHTTPHeaderField: "Accept")
        request.addValue("Bearer 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", forHTTPHeaderField: "Authorization")
        request.addValue("2022-11-28", forHTTPHeaderField: "X-GitHub-Api-Version")
        
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        
        return URLSession.shared.dataTaskPublisher(for: request)
            .tryMap { output in
                guard let httpResponse = output.response as? HTTPURLResponse,
                      httpResponse.statusCode == 200 else {
                    throw URLError(.badServerResponse)
                }
                return output.data
            }
            .decode(type: [Event].self, decoder: decoder)
            .eraseToAnyPublisher()
    }
}
