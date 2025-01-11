// ViewModels/AuthViewModel.swift
import Foundation
import Combine

/// ViewModel for handling authentication actions.
final class AuthViewModel: ObservableObject {
    
    // Published variables for UI binding.
    @Published var currentUser: User?
    @Published var isAuthenticated: Bool = false
    @Published var errorMessage: String?
    
    // Base URL for authentication endpoints.
    private let authBaseURL = "https://your-backend-url.com/api/auth"
    
    /// Registers a new user.
    /// - Parameters:
    ///   - username: User’s desired username.
    ///   - email: User’s email.
    ///   - password: User’s password.
    func register(username: String, email: String, password: String) {
        guard let url = URL(string: "\(authBaseURL)/register") else {
            self.errorMessage = "Invalid URL."
            return
        }
        
        let parameters: [String: Any] = [
            "username": username,
            "email": email,
            "password": password
        ]
        
        guard let jsonData = try? JSONSerialization.data(withJSONObject: parameters) else {
            self.errorMessage = "Invalid parameters."
            return
        }
        
        NetworkManager.shared.request(url: url,
                                      method: .post,
                                      headers: ["Content-Type": "application/json"],
                                      body: jsonData) { (result: Result<User, APIError>) in
            switch result {
            case .success(let user):
                self.currentUser = user
                self.isAuthenticated = true
                // Optionally: Store token securely.
            case .failure(let error):
                self.errorMessage = error.localizedDescription
            }
        }
    }
    
    /// Logs in an existing user.
    /// - Parameters:
    ///   - email: User’s email.
    ///   - password: User’s password.
    func login(email: String, password: String) {
        guard let url = URL(string: "\(authBaseURL)/login") else {
            self.errorMessage = "Invalid URL."
            return
        }
        
        let parameters: [String: Any] = [
            "email": email,
            "password": password
        ]
        
        guard let jsonData = try? JSONSerialization.data(withJSONObject: parameters) else {
            self.errorMessage = "Invalid parameters."
            return
        }
        
        NetworkManager.shared.request(url: url,
                                      method: .post,
                                      headers: ["Content-Type": "application/json"],
                                      body: jsonData) { (result: Result<User, APIError>) in
            switch result {
            case .success(let user):
                self.currentUser = user
                self.isAuthenticated = true
            case .failure(let error):
                self.errorMessage = error.localizedDescription
            }
        }
    }
    
    /// Logs out the current user.
    func logout() {
        guard let url = URL(string: "\(authBaseURL)/logout") else {
            self.errorMessage = "Invalid URL."
            return
        }
        
        // Prepare headers (include token if available).
        var headers: [String: String] = ["Content-Type": "application/json"]
        if let token = currentUser?.token {
            headers["Authorization"] = "Bearer \(token)"
        }
        
        NetworkManager.shared.request(url: url,
                                      method: .post,
                                      headers: headers,
                                      body: nil) { (result: Result<[String: String], APIError>) in
            switch result {
            case .success:
                self.currentUser = nil
                self.isAuthenticated = false
            case .failure(let error):
                self.errorMessage = error.localizedDescription
            }
        }
    }
}
