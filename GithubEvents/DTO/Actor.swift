import Foundation

public struct Actor: Decodable {
    let id: Int
    let login: String
    let url: URL
    let avatarUrl: URL
    
    enum CodingKeys: String, CodingKey {
        case id
        case login
        case url
        case avatarUrl = "avatar_url"
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(Int.self, forKey: .id)
        self.login = try container.decode(String.self, forKey: .login)
        self.url = try container.decode(URL.self, forKey: .url)
        self.avatarUrl = try container.decode(URL.self, forKey: .avatarUrl)
    }
    
    public init(
        id: Int,
        login: String,
        url: URL,
        avatarUrl: URL
    ) {
        self.id = id
        self.login = login
        self.url = url
        self.avatarUrl = avatarUrl
    }
}
