// SpectrumSync/Models/Event.swift

import Foundation

struct Event: Codable, Identifiable {
    let id: Int
    let title: String
    let description: String?
    let date: String
    let location: String
    let userId: Int
    let createdAt: String?

    enum CodingKeys: String, CodingKey {
        case id
        case title
        case description
        case date
        case location
        case userId = "userId"
        case createdAt = "created_at"
    }
}
