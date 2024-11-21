import Foundation

public struct Event: Decodable {
    let id: String
    let type: EventType
    let actor: Actor
    let repo: Repo
}
