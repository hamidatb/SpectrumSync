// Models/User.swift
import Foundation

/// Represents a User returned by the backend.
struct User: Codable, Identifiable {
    let id: Int
    let username: String
    let email: String
    let token: String?
}
