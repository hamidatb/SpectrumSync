// ViewModels/AuthViewModel.swift
import Foundation
import Combine

/// ViewModel for handling authentication actions.
final class AuthViewModel: ObservableObject {
    // Published variables for UI binding.
    @Published var currentUser: User?
    @Published var isAuthenticated: Bool = false
    @Published var errorMessage: String?
    
    private let networkService: NetworkService
    private let authBaseURL = "https://spectrum-sync-backend-g3hnfve7h3fdbuf4.canadacentral-01.azurewebsites.net/api/auth"
    
    // Inject NetworkService
    init(networkService: NetworkService = NetworkManager.shared) {
        self.networkService = networkService
        print("AuthViewModel initialized with networkService: \(networkService)")
    }
    
    // Register a new user.
    func register(username: String, email: String, password: String) {
        print("Register function called with username: \(username), email: \(email)")
        guard let url = URL(string: "\(authBaseURL)/register") else {
            self.errorMessage = "Invalid URL."
            print("Error: Invalid URL for registration.")
            return
        }
        
        // Validate email format.
        guard email.contains("@"), email.contains(".") else {
            errorMessage = "Please enter a valid email address."
            print("Error: Invalid email format.")
            return
        }
        
        // Validate password length.
        guard password.count >= 6 else {
            errorMessage = "Password must be at least 6 characters long."
            print("Error: Password too short.")
            return
        }
        
        // Validate username is not empty.
        guard !username.trimmingCharacters(in: .whitespaces).isEmpty else {
            errorMessage = "Username cannot be empty."
            print("Error: Username is empty.")
            return
        }
        
        // Convert email to lowercase before sending.
        let lowercasedEmail = email.lowercased()
        
        let parameters: [String: Any] = [
            "username": username,
            "email": lowercasedEmail,
            "password": password
        ]
        
        guard let jsonData = try? JSONSerialization.data(withJSONObject: parameters) else {
            self.errorMessage = "Invalid parameters."
            print("Error: Failed to serialize registration parameters.")
            return
        }
        
        networkService.request(
            url: url,
            method: .post,
            headers: ["Content-Type": "application/json"],
            body: jsonData
        ) { (result: Result<AuthResponse, APIError>) in
            switch result {
            case .success(let authResponse):
                print("Registration API success: \(authResponse.message)")
                
                DispatchQueue.main.async {
                    var loggedInUser = authResponse.user
                    loggedInUser.token = authResponse.token
                    self.currentUser = loggedInUser
                    self.isAuthenticated = true
                }
                
            case .failure(let error):
                DispatchQueue.main.async {
                    if case APIError.httpError(let code) = error, code == 400 {
                        self.errorMessage = "A user already exists with that email"
                        print("Registration failed: User already exists (400 error).")
                    } else {
                        self.errorMessage = "Registration failed, please try again."
                        print("Registration API error: \(error.localizedDescription)")
                    }
                }
            }
        }
    }
    
    // Login an existing user.
    func login(email: String, password: String) {
        print("Login function called with email: \(email)")
        guard let url = URL(string: "\(authBaseURL)/login") else {
            self.errorMessage = "Invalid URL."
            print("Error: Invalid URL for login.")
            return
        }
        
        let parameters: [String: Any] = [
            "email": email.lowercased(),
            "password": password
        ]
        
        guard let jsonData = try? JSONSerialization.data(withJSONObject: parameters) else {
            self.errorMessage = "Invalid parameters."
            print("Error: Failed to serialize login parameters.")
            return
        }
        
        networkService.request(
            url: url,
            method: .post,
            headers: ["Content-Type": "application/json"],
            body: jsonData
        ) { (result: Result<AuthResponse, APIError>) in
            switch result {
            case .success(let authResponse):
                print("Login API success: \(authResponse.message)")
                
                DispatchQueue.main.async {
                    var loggedInUser = authResponse.user
                    loggedInUser.token = authResponse.token
                    self.currentUser = loggedInUser
                    self.isAuthenticated = true
                    print("LoggedInUser: \(loggedInUser), token: \(String(describing: loggedInUser.token)), isAuthenticated = \(self.isAuthenticated)")
                    print("Login successful! Navigating to HomeView.")
                }
                
            case .failure(let error):
                DispatchQueue.main.async {
                    if case APIError.httpError(let code) = error, code == 400 {
                        self.errorMessage = "Invalid credentials"
                        print("Login failed: Invalid credentials (400 error).")
                    } else {
                        self.errorMessage = "Login failed, please try again."
                        print("Login API error: \(error.localizedDescription)")
                    }
                }
            }
        }
    }
    
    // Logout the current user.
    func logout() {
        print("Logout function called.")
        guard let url = URL(string: "\(authBaseURL)/logout") else {
            self.errorMessage = "Invalid URL."
            print("Error: Invalid URL for logout.")
            return
        }
        
        // Prepare headers (include token if available).
        var headers: [String: String] = ["Content-Type": "application/json"]
        if let token = currentUser?.token {
            headers["Authorization"] = "Bearer \(token)"
        }
        
        networkService.request(
            url: url,
            method: .post,
            headers: headers,
            body: nil
        ) { (result: Result<[String: String], APIError>) in
            switch result {
            case .success:
                print("Logout successful.")
                self.currentUser = nil
                self.isAuthenticated = false
            case .failure(let error):
                print("Logout error: \(error.localizedDescription)")
                self.errorMessage = error.localizedDescription
            }
        }
    }
}
