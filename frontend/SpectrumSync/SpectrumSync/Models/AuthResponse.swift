// Models/AuthResponse.swift
import Foundation

struct AuthResponse: Decodable {
    let message: String
    let token: String
    let user: User
}
