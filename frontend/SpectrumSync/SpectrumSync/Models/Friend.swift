// Models/Friend.swift
import Foundation

/// Represents a Friend.
struct Friend: Codable, Identifiable {
    let id: Int
    let username: String
    let email: String
}
