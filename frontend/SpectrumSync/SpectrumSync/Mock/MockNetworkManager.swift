// Mock/MockNetworkManager.swift
import Foundation

final class MockNetworkManager: NetworkService {
    static let shared = MockNetworkManager()
    private init() {}
    
    func request<T: Decodable>(
        url: URL,
        method: HTTPMethod = .get,
        headers: [String : String]? = nil,
        body: Data? = nil,
        completion: @escaping (Result<T, APIError>) -> Void
    ) {
        print("[MockNetworkManager] \(method.rawValue) \(url.absoluteString)")
        
        // Simulate network delay
        DispatchQueue.global().asyncAfter(deadline: .now() + 1) { // 1 second delay
            // Handle different endpoints based on URL
            let path = url.path.lowercased()
            // Print current environment for debugging
            print("Path hit: \(path)")
                    
            
            // Handle Auth Endpoints
            if path.contains("/login"), T.self == AuthResponse.self {
                let mockUser = User(
                    userId: 1,
                    username: "DemoKid",
                    email: "demo.kid@example.com",
                    role: "child",
                    token: "mockToken",
                    linkedChildIds: nil
                )
                let mockResponse = AuthResponse(
                    message: "Mock user login successful",
                    token: "mockToken123",
                    user: mockUser
                )
                completion(.success(mockResponse as! T))
                return
            }

            if path.contains("/register"), T.self == AuthResponse.self {
                let mockUser = User(
                    userId: 2,
                    username: "NewKid",
                    email: "new.kid@example.com",
                    role: "child",
                    token: "newMockToken456",
                    linkedChildIds: nil
                )
                let mockResponse = AuthResponse(
                    message: "Registration successful",
                    token: "newMockToken456",
                    user: mockUser
                )
                completion(.success(mockResponse as! T))
                return
            }

            
            if path.contains("/logout"), T.self == [String: String].self {
                let mockResponse = ["message": "Logout successful"]
                completion(.success(mockResponse as! T))
                return
            }
            
            // Handle Event Endpoints
            if path.contains("/events"), T.self == [Event].self {
                let mockEvents = [
                    Event(
                        id: 1,
                        title: "Mock Event 1",
                        description: "Description for Mock Event 1",
                        date: isoDate("2025-02-01T09:00:00Z"),
                        location: "Mock Location 1",
                        userId: 1,
                        createdAt: isoDate("2025-01-01T10:00:00Z"),
                        withWho: nil
                    ),
                    Event(
                        id: 2,
                        title: "Mock Event 2",
                        description: "Description for Mock Event 2",
                        date: isoDate("2025-03-15T14:30:00Z"),
                        location: "Mock Location 2",
                        userId: 1,
                        createdAt: isoDate("2025-01-02T11:30:00Z"),
                        withWho: "Dad"
                    )
                ]
                completion(.success(mockEvents as! T))
                return
            }
            
            if path.contains("/events/invites"), T.self == [Event].self {
                let mockInvites = [
                    Event(
                                id: 3,
                                title: "Invited Event 1",
                                description: "You are invited to this event.",
                                date: isoDate("2025-04-20T15:00:00Z"),
                                location: "Invitation Location 1",
                                userId: 2,
                                createdAt: isoDate("2025-01-03T12:45:00Z"),
                                withWho: "Friend A"
                            ),
                            Event(
                                id: 4,
                                title: "Invited Event 2",
                                description: "Join us for this event.",
                                date: isoDate("2025-05-10T11:30:00Z"),
                                location: "Invitation Location 2",
                                userId: 3,
                                createdAt: isoDate("2025-01-04T14:00:00Z"),
                                withWho: "Friend B"
                            )
                ]
                completion(.success(mockInvites as! T))
                return
            }
            
            if path.contains("/events/create"), T.self == [String: String].self {
                let mockResponse = ["message": "Event created successfully"]
                completion(.success(mockResponse as! T))
                return
            }
            
            if path.contains("/events/share"), T.self == [String: String].self {
                let mockResponse = ["message": "Event shared successfully"]
                completion(.success(mockResponse as! T))
                return
            }
            
            if path.contains("/events/attend"), T.self == [String: String].self {
                let mockResponse = ["message": "RSVP status updated successfully"]
                completion(.success(mockResponse as! T))
                return
            }
            
            // Handle Chat Endpoints
            if path.contains("/chats/create"), T.self == [String: String].self {
                let mockResponse = ["message": "Chat created successfully"]
                completion(.success(mockResponse as! T))
                return
            }
            
            if path.contains("/chats/join"), T.self == [String: String].self {
                let mockResponse = ["message": "Joined chat successfully"]
                completion(.success(mockResponse as! T))
                return
            }
            
            if path.contains("/chats/leave"), T.self == [String: String].self {
                let mockResponse = ["message": "Left chat successfully"]
                completion(.success(mockResponse as! T))
                return
            }
            
            if path.contains("/chats/message"), T.self == [String: String].self {
                let mockResponse = ["message": "Message sent successfully"]
                completion(.success(mockResponse as! T))
                return
            }
            
            if path.contains("/chats/invite"), T.self == [String: String].self {
                let mockResponse = ["message": "Chat invite sent successfully"]
                completion(.success(mockResponse as! T))
                return
            }
            
            if path.contains("/chats/invite/accept"), T.self == [String: String].self {
                let mockResponse = ["message": "Chat invite accepted successfully"]
                completion(.success(mockResponse as! T))
                return
            }
            
            if path.contains("/chats/messages"), T.self == [ChatMessage].self {
                let mockMessages = [
                    ChatMessage(id: 1, chatId: 1, senderId: 1, content: "Hello!", timestamp: "2025-02-01T10:05:00Z"),
                    ChatMessage(id: 2, chatId: 1, senderId: 2, content: "Hi there!", timestamp: "2025-02-01T10:06:00Z")
                ]
                completion(.success(mockMessages as! T))
                return
            }
            
            if path.contains("/chats"), method == .get, T.self == [Chat].self {
                let mockChats = [
                    Chat(id: 1, chatName: "Individual Chat", userIds: [1, 2], isGroupChat: false),
                    Chat(id: 2, chatName: "Group Chat", userIds: [1, 3], isGroupChat: true)
                ]
                completion(.success(mockChats as! T))
                return
            }
            
            // Handle Friend Endpoints
            if path.contains("/friends/add"), T.self == [String: String].self {
                let mockResponse = ["message": "Friend added successfully"]
                completion(.success(mockResponse as! T))
                return
            }
            
            if path.contains("/friends/remove"), T.self == [String: String].self {
                let mockResponse = ["message": "Friend removed successfully"]
                completion(.success(mockResponse as! T))
                return
            }
            
            if path.contains("/friends/list"), T.self == [Friend].self {
                let mockFriends = [
                    Friend(id: 2, username: "FriendOne", email: "friend1@example.com"),
                    Friend(id: 3, username: "FriendTwo", email: "friend2@example.com")
                ]
                completion(.success(mockFriends as! T))
                return
            }
            
            // Default mock response
            completion(.failure(.unknown))
        }
    }
}
