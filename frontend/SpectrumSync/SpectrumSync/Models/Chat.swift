// Models/Chat.swift
import Foundation

/// Represents a Chat.
struct Chat: Codable, Identifiable {
    let id: Int
    let chatName: String?
    let userIds: [Int]
    let isGroupChat: Bool
}
