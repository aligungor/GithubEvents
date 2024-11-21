import Foundation

public struct Event: Decodable {
    let id: String
    let type: EventType
    let actor: Actor
    let repo: Repo
    let createdAt: Date
    
    enum CodingKeys: String, CodingKey {
        case id
        case type
        case actor
        case repo
        case createdAt = "created_at"
    }
}
