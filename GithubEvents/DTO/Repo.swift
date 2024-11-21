import Foundation

public struct Repo: Decodable {
    let id: Int
    let url: URL
    let name: String
}
