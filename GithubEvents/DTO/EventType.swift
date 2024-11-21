import Foundation

public enum EventType: String, CaseIterable, Decodable {
    case watchEvent = "WatchEvent"
    case pushEvent = "PushEvent"
    case pullRequestEvent = "PullRequestEvent"
    case releaseEvent = "ReleaseEvent"
    case forkEvent = "ForkEvent"
    case unknown = "Unknown Event"
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let rawValue = try? container.decode(String.self)
        self = EventType(rawValue: rawValue ?? "") ?? .unknown
    }
}
