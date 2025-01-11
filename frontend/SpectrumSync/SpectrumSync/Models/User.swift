// SpectrumSync/Models/User.swift

import Foundation

struct User: Codable {
    let id: Int
    let username: String
    let email: String
    let token: String?
}
