// SpectrumSync/Models/Event.swift

import Foundation

struct Event: Codable, Identifiable, Hashable {
    let id: Int
    let title: String
    let description: String?
    let date: Date
    let location: String?
    let userId: Int
    let createdAt: Date?
    let withWho: [String]?

    enum CodingKeys: String, CodingKey {
        case id = "eventId"
        case title
        case description
        case date
        case location
        case userId = "userId"
        case createdAt
        case withWho
    }
}
