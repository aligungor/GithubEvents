import Foundation

struct EventCellViewModel {
    let id: String
    let avatarURL: URL
    let actorLogin: String
    let repoName: String
    let eventType: String
    let relativeTime: String
    
    init(event: Event) {
        self.id = event.id
        self.avatarURL = event.actor.avatarUrl
        self.actorLogin = event.actor.login
        self.repoName = event.repo.name
        self.eventType = event.type.rawValue
        self.relativeTime = EventCellViewModel.getRelativeTime(from: event.createdAt)
    }
    
    private static func getRelativeTime(from date: Date) -> String {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.second, .minute, .hour, .day]
        formatter.maximumUnitCount = 1
        formatter.unitsStyle = .short
        
        let difference = formatter.string(from: date, to: Date()) ?? "0s"
        return difference + " ago"
    }
}
