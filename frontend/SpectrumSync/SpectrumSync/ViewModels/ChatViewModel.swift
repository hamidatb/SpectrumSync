// ViewModels/ChatViewModel.swift
import Foundation
import Combine

/// A model for a chat message.
struct ChatMessage: Codable, Identifiable {
    let id: Int
    let chatId: Int
    let senderId: Int
    let content: String
    let timestamp: String
}


/// ViewModel for chat-related actions.
final class ChatViewModel: ObservableObject {
    @Published var chats: [Chat] = []
    @Published var chatMessages: [ChatMessage] = []
    @Published var errorMessage: String?
    
    private let networkService: NetworkService
    private let chatBaseURL = "https://your-backend-url.com/api/chats"
    private var token: String?
    
    /// Initializes the ChatViewModel with a NetworkService.
    /// - Parameter networkService: The network service to use (default is NetworkManager.shared).
    init(networkService: NetworkService = NetworkManager.shared) {
        self.networkService = networkService
        print("ChatViewModel initialized with networkService: \(networkService)")
    }
    
    /// Sets the authentication token.
    func setToken(_ token: String) {
        self.token = token
    }
    
    /// Creates a new chat.
    /// - Parameter parameters: Dictionary containing chat parameters (e.g., "userIds", optionally "chatName").
    func createChat(parameters: [String: Any]) {
        guard let url = URL(string: "\(chatBaseURL)/create") else {
            DispatchQueue.main.async {
                self.errorMessage = "Invalid URL."
            }
            return
        }
        
        guard let jsonData = try? JSONSerialization.data(withJSONObject: parameters) else {
            DispatchQueue.main.async {
                self.errorMessage = "Invalid parameters."
            }
            return
        }
        
        var headers = ["Content-Type": "application/json"]
        if let token = token { headers["Authorization"] = "Bearer \(token)" }
        
        networkService.request(url: url,
                               method: .post,
                               headers: headers,
                               body: jsonData) { (result: Result<[String: String], APIError>) in
            DispatchQueue.main.async {
                switch result {
                case .success(let response):
                    print("Chat created: \(response)")
                    // Optionally refresh the chat list.
                case .failure(let error):
                    self.errorMessage = error.localizedDescription
                }
            }
        }
    }
    
    /// Joins an existing chat.
    /// - Parameter chatId: Chat identifier.
    func joinChat(chatId: Int) {
        guard let url = URL(string: "\(chatBaseURL)/join/\(chatId)") else {
            DispatchQueue.main.async {
                self.errorMessage = "Invalid URL."
            }
            return
        }
        
        var headers = [String: String]()
        if let token = token { headers["Authorization"] = "Bearer \(token)" }
        
        networkService.request(url: url,
                               method: .post,
                               headers: headers,
                               body: nil) { (result: Result<[String: String], APIError>) in
            DispatchQueue.main.async {
                switch result {
                case .success(let response):
                    print("Joined chat: \(response)")
                case .failure(let error):
                    self.errorMessage = error.localizedDescription
                }
            }
        }
    }
    
    /// Leaves a chat.
    /// - Parameter chatId: Chat identifier.
    func leaveChat(chatId: Int) {
        guard let url = URL(string: "\(chatBaseURL)/leave/\(chatId)") else {
            DispatchQueue.main.async {
                self.errorMessage = "Invalid URL."
            }
            return
        }
        var headers = [String: String]()
        if let token = token { headers["Authorization"] = "Bearer \(token)" }
        
        networkService.request(url: url,
                               method: .post,
                               headers: headers,
                               body: nil) { (result: Result<[String: String], APIError>) in
            DispatchQueue.main.async {
                switch result {
                case .success(let response):
                    print("Left chat: \(response)")
                case .failure(let error):
                    self.errorMessage = error.localizedDescription
                }
            }
        }
    }
    
    /// Sends a message to a chat.
    /// - Parameters:
    ///   - chatId: Chat identifier.
    ///   - content: Message text.
    func sendMessage(chatId: Int, content: String) {
        guard let url = URL(string: "\(chatBaseURL)/message/\(chatId)") else {
            DispatchQueue.main.async {
                self.errorMessage = "Invalid URL."
            }
            return
        }
        
        let parameters: [String: Any] = ["content": content]
        guard let jsonData = try? JSONSerialization.data(withJSONObject: parameters) else {
            DispatchQueue.main.async {
                self.errorMessage = "Invalid parameters."
            }
            return
        }
        var headers = ["Content-Type": "application/json"]
        if let token = token { headers["Authorization"] = "Bearer \(token)" }
        
        networkService.request(url: url,
                               method: .post,
                               headers: headers,
                               body: jsonData) { (result: Result<[String: String], APIError>) in
            DispatchQueue.main.async {
                switch result {
                case .success(let response):
                    print("Message sent: \(response)")
                    // Optionally refresh messages.
                case .failure(let error):
                    self.errorMessage = error.localizedDescription
                }
            }
        }
    }
    
    /// Lists all chats for the authenticated user.
    func listAllChats() {
        guard let url = URL(string: "\(chatBaseURL)") else {
            DispatchQueue.main.async {
                self.errorMessage = "Invalid URL."
            }
            return
        }
        var headers = [String: String]()
        if let token = token { headers["Authorization"] = "Bearer \(token)" }
        
        networkService.request(url: url,
                               method: .get,
                               headers: headers,
                               body: nil) { (result: Result<[Chat], APIError>) in
            DispatchQueue.main.async {
                switch result {
                case .success(let chats):
                    self.chats = chats
                case .failure(let error):
                    self.errorMessage = error.localizedDescription
                }
            }
        }
    }
    
    /// Fetches the 20 most recent messages for a chat.
    /// - Parameter chatId: Chat identifier.
    func getMostRecentChatMessages(chatId: Int) {
        guard let url = URL(string: "\(chatBaseURL)/\(chatId)/messages") else {
            DispatchQueue.main.async {
                self.errorMessage = "Invalid URL."
            }
            return
        }
        var headers = [String: String]()
        if let token = token { headers["Authorization"] = "Bearer \(token)" }
        
        networkService.request(url: url,
                               method: .get,
                               headers: headers,
                               body: nil) { (result: Result<[ChatMessage], APIError>) in
            DispatchQueue.main.async {
                switch result {
                case .success(let messages):
                    self.chatMessages = messages
                case .failure(let error):
                    self.errorMessage = error.localizedDescription
                }
            }
        }
    }
    
    /// Sends a chat invite to a user.
    /// - Parameters:
    ///   - chatId: Chat identifier.
    ///   - inviteeUserId: The user ID to invite.
    func sendChatInvite(chatId: Int, inviteeUserId: Int) {
        guard let url = URL(string: "\(chatBaseURL)/\(chatId)/invite") else {
            DispatchQueue.main.async {
                self.errorMessage = "Invalid URL."
            }
            return
        }
        let parameters: [String: Any] = ["inviteeUserId": inviteeUserId]
        guard let jsonData = try? JSONSerialization.data(withJSONObject: parameters) else {
            DispatchQueue.main.async {
                self.errorMessage = "Invalid parameters."
            }
            return
        }
        var headers = ["Content-Type": "application/json"]
        if let token = token { headers["Authorization"] = "Bearer \(token)" }
        
        networkService.request(url: url,
                               method: .post,
                               headers: headers,
                               body: jsonData) { (result: Result<[String: String], APIError>) in
            DispatchQueue.main.async {
                switch result {
                case .success(let response):
                    print("Invite sent: \(response)")
                case .failure(let error):
                    self.errorMessage = error.localizedDescription
                }
            }
        }
    }
    
    /// Accepts a chat invite.
    /// - Parameter inviteToken: The invite token provided in the URL.
    func acceptChatInvite(inviteToken: String) {
        guard let url = URL(string: "\(chatBaseURL)/invite/accept?token=\(inviteToken)") else {
            DispatchQueue.main.async {
                self.errorMessage = "Invalid URL."
            }
            return
        }
        var headers = [String: String]()
        if let token = token { headers["Authorization"] = "Bearer \(token)" }
        
        networkService.request(url: url,
                               method: .get,
                               headers: headers,
                               body: nil) { (result: Result<[String: String], APIError>) in
            DispatchQueue.main.async {
                switch result {
                case .success(let response):
                    print("Invite accepted: \(response)")
                case .failure(let error):
                    self.errorMessage = error.localizedDescription
                }
            }
        }
    }
}
