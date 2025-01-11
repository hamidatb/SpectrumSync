// ViewModels/FriendViewModel.swift
import Foundation
import Combine

/// ViewModel for handling friend-related actions.
final class FriendViewModel: ObservableObject {
    @Published var friends: [Friend] = []
    @Published var errorMessage: String?
    
    private let friendBaseURL = "https://your-backend-url.com/api/friends"
    private var token: String?
    
    /// Sets the authentication token.
    func setToken(_ token: String) {
        self.token = token
    }
    
    /// Adds a friend.
    func addFriend(friendUserId: Int) {
        guard let url = URL(string: "\(friendBaseURL)/add") else {
            self.errorMessage = "Invalid URL."
            return
        }
        let parameters: [String: Any] = ["friendUserId": friendUserId]
        guard let jsonData = try? JSONSerialization.data(withJSONObject: parameters) else {
            self.errorMessage = "Invalid parameters."
            return
        }
        var headers = ["Content-Type": "application/json"]
        if let token = token { headers["Authorization"] = "Bearer \(token)" }
        
        NetworkManager.shared.request(url: url,
                                      method: .post,
                                      headers: headers,
                                      body: jsonData) { (result: Result<[String: String], APIError>) in
            switch result {
            case .success(let response):
                print("Friend added: \(response)")
                self.getFriendsList()
            case .failure(let error):
                self.errorMessage = error.localizedDescription
            }
        }
    }
    
    /// Removes a friend.
    func removeFriend(friendUserId: Int) {
        guard let url = URL(string: "\(friendBaseURL)/remove") else {
            self.errorMessage = "Invalid URL."
            return
        }
        let parameters: [String: Any] = ["friendUserId": friendUserId]
        guard let jsonData = try? JSONSerialization.data(withJSONObject: parameters) else {
            self.errorMessage = "Invalid parameters."
            return
        }
        var headers = ["Content-Type": "application/json"]
        if let token = token { headers["Authorization"] = "Bearer \(token)" }
        
        NetworkManager.shared.request(url: url,
                                      method: .post,
                                      headers: headers,
                                      body: jsonData) { (result: Result<[String: String], APIError>) in
            switch result {
            case .success(let response):
                print("Friend removed: \(response)")
                self.getFriendsList()
            case .failure(let error):
                self.errorMessage = error.localizedDescription
            }
        }
    }
    
    /// Retrieves the authenticated user’s friends list.
    func getFriendsList() {
        guard let url = URL(string: "\(friendBaseURL)/list") else {
            self.errorMessage = "Invalid URL."
            return
        }
        var headers = [String: String]()
        if let token = token { headers["Authorization"] = "Bearer \(token)" }
        
        NetworkManager.shared.request(url: url,
                                      method: .get,
                                      headers: headers,
                                      body: nil) { (result: Result<[Friend], APIError>) in
            switch result {
            case .success(let friends):
                self.friends = friends
            case .failure(let error):
                self.errorMessage = error.localizedDescription
            }
        }
    }
}
