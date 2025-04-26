// ViewModels/FriendViewModel.swift
import Foundation
import Combine

/// ViewModel for handling friend-related actions.
final class FriendViewModel: ObservableObject {
    @Published var friends: [Friend] = []
    @Published var errorMessage: String?
    
    private let networkService: NetworkService
    private let friendBaseURL = "https:/https://spectrum-sync-backend-g3hnfve7h3fdbuf4.canadacentral-01.azurewebsites.net/api/friends"
    private var token: String?
    
    /// Initializes the FriendViewModel with a NetworkService.
    /// - Parameter networkService: The network service to use (default is NetworkManager.shared).
    init(networkService: NetworkService = NetworkManager.shared) {
        self.networkService = networkService
        print("FriendViewModel initialized with networkService: \(networkService)")
    }
    
    /// Sets the authentication token.
    func setToken(_ token: String) {
        self.token = token
    }
    
    /// Adds a friend.
    func addFriend(friendUserId: Int) {
        guard let url = URL(string: "\(friendBaseURL)/add") else {
            DispatchQueue.main.async {
                self.errorMessage = "Invalid URL."
            }
            return
        }
        let parameters: [String: Any] = ["friendUserId": friendUserId]
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
                    print("Friend added: \(response)")
                    self.getFriendsList()
                case .failure(let error):
                    self.errorMessage = error.localizedDescription
                }
            }
        }
    }
    
    /// Removes a friend.
    func removeFriend(friendUserId: Int) {
        guard let url = URL(string: "\(friendBaseURL)/remove") else {
            DispatchQueue.main.async {
                self.errorMessage = "Invalid URL."
            }
            return
        }
        let parameters: [String: Any] = ["friendUserId": friendUserId]
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
                    print("Friend removed: \(response)")
                    self.getFriendsList()
                case .failure(let error):
                    self.errorMessage = error.localizedDescription
                }
            }
        }
    }
    
    /// Retrieves the authenticated user’s friends list.
    func getFriendsList() {
        guard let url = URL(string: "\(friendBaseURL)/list") else {
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
                               body: nil) { (result: Result<[Friend], APIError>) in
            DispatchQueue.main.async {
                switch result {
                case .success(let friends):
                    self.friends = friends
                case .failure(let error):
                    self.errorMessage = error.localizedDescription
                }
            }
        }
    }
}
