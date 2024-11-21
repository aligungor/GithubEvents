import Foundation

struct EventCellViewModel {
    let id: String
    let avatarURL: URL
    let actorLogin: String
    let repoName: String
    let eventType: String
    
    init(event: Event) {
        self.id = event.id
        self.avatarURL = event.actor.avatarUrl
        self.actorLogin = event.actor.login
        self.repoName = event.repo.name
        self.eventType = event.type.rawValue
    }
}
