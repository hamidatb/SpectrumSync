// SpectrumSync/ViewModels/AuthViewModel.swift

import Foundation
import Combine

class AuthViewModel: ObservableObject {
    @Published var user: User?
    @Published var isAuthenticated: Bool = false
    @Published var errorMessage: String?

    private let baseURL = "https://spectrum-sync-backend.azurewebsites.net/api/auth"

    // Register User
    func register(username: String, email: String, password: String) {
        guard let url = URL(string: "\(baseURL)/register") else {
            print("Invalid URL")
            return
        }

        let parameters = ["username": username, "email": email, "password": password]

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("Application/json", forHTTPHeaderField: "Content-Type")

        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: [])
        } catch {
            print("Error serializing JSON:", error)
            return
        }

        URLSession.shared.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                if let error = error {
                    self.errorMessage = error.localizedDescription
                    return
                }

                guard let data = data else {
                    self.errorMessage = "No data received"
                    return
                }

                do {
                    let decodedUser = try JSONDecoder().decode(User.self, from: data)
                    self.user = decodedUser
                    self.isAuthenticated = true
                } catch {
                    self.errorMessage = "Registration failed: \(error.localizedDescription)"
                }
            }
        }.resume()
    }

    // Login User
    func login(email: String, password: String) {
        guard let url = URL(string: "\(baseURL)/login") else {
            print("Invalid URL")
            return
        }

        let parameters = ["email": email, "password": password]

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("Application/json", forHTTPHeaderField: "Content-Type")

        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: [])
        } catch {
            print("Error serializing JSON:", error)
            return
        }

        URLSession.shared.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                if let error = error {
                    self.errorMessage = error.localizedDescription
                    return
                }

                guard let data = data else {
                    self.errorMessage = "No data received"
                    return
                }

                do {
                    let decodedUser = try JSONDecoder().decode(User.self, from: data)
                    self.user = decodedUser
                    self.isAuthenticated = true
                } catch {
                    self.errorMessage = "Login failed: \(error.localizedDescription)"
                }
            }
        }.resume()
    }

    // Logout User
    func logout() {
        self.user = nil
        self.isAuthenticated = false
    }
}
