import Foundation

protocol EventDetailsViewModelProtocol {
    var eventType: String { get }
    var actorLogin: String { get }
    var repoURL: URL { get }
    var avatarURL: URL { get }
}

class EventDetailsViewModel: EventDetailsViewModelProtocol {
    private let event: Event
    
    var eventType: String {
        return event.type.rawValue
    }

    var actorLogin: String {
        return event.actor.login
    }

    var repoURL: URL {
        return URL(string: "https://github.com/" + event.repo.name)!
    }

    var avatarURL: URL {
        return event.actor.avatarUrl
    }

    init(event: Event) {
        self.event = event
    }
}
