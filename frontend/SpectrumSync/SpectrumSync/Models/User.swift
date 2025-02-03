// Models/User.swift
import Foundation

/// Represents a User returned by the backend.
struct User: Decodable {
    let userId: Int
    let username: String
    let email: String
    var token: String  // JWT for authentication throughout the app
}
