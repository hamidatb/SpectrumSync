// ViewModels/EventViewModel.swift
import Foundation
import Combine

/// ViewModel for handling event-related actions.
final class EventViewModel: ObservableObject {
    @Published var events: [Event] = []
    @Published var invites: [Event] = []  // Assuming event invitations are returned as events.
    @Published var errorMessage: String?
    
    private let eventBaseURL = "https://your-backend-url.com/api/events"
    private var token: String?
    
    /// Sets the authentication token.
    func setToken(_ token: String) {
        self.token = token
    }
    
    /// Fetches event invitations for the authenticated user.
    func getInvites() {
        guard let url = URL(string: "\(eventBaseURL)/invites") else {
            self.errorMessage = "Invalid URL."
            return
        }
        var headers = [String: String]()
        if let token = token { headers["Authorization"] = "Bearer \(token)" }
        
        NetworkManager.shared.request(url: url,
                                      method: .get,
                                      headers: headers,
                                      body: nil) { (result: Result<[Event], APIError>) in
            switch result {
            case .success(let invites):
                self.invites = invites
            case .failure(let error):
                self.errorMessage = error.localizedDescription
            }
        }
    }
    
    /// Creates a new event.
    func createEvent(title: String, description: String?, date: String, location: String) {
        guard let url = URL(string: "\(eventBaseURL)") else {
            self.errorMessage = "Invalid URL."
            return
        }
        let parameters: [String: Any] = [
            "title": title,
            "description": description ?? "",
            "date": date,
            "location": location
        ]
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
                print("Event created: \(response)")
                self.getEvents() // Refresh events after creation.
            case .failure(let error):
                self.errorMessage = error.localizedDescription
            }
        }
    }
    
    /// Retrieves all events for the authenticated user.
    func getEvents() {
        guard let url = URL(string: "\(eventBaseURL)") else {
            self.errorMessage = "Invalid URL."
            return
        }
        var headers = [String: String]()
        if let token = token { headers["Authorization"] = "Bearer \(token)" }
        
        NetworkManager.shared.request(url: url,
                                      method: .get,
                                      headers: headers,
                                      body: nil) { (result: Result<[Event], APIError>) in
            switch result {
            case .success(let events):
                self.events = events
            case .failure(let error):
                self.errorMessage = error.localizedDescription
            }
        }
    }
    
    /// Retrieves an event by its ID.
    func getEventById(eventId: Int, completion: @escaping (Event?) -> Void) {
        guard let url = URL(string: "\(eventBaseURL)/\(eventId)") else {
            self.errorMessage = "Invalid URL."
            completion(nil)
            return
        }
        var headers = [String: String]()
        if let token = token { headers["Authorization"] = "Bearer \(token)" }
        
        NetworkManager.shared.request(url: url,
                                      method: .get,
                                      headers: headers,
                                      body: nil) { (result: Result<Event, APIError>) in
            switch result {
            case .success(let event):
                completion(event)
            case .failure(let error):
                self.errorMessage = error.localizedDescription
                completion(nil)
            }
        }
    }
    
    /// Updates an event by its ID.
    func updateEvent(eventId: Int, title: String, description: String?, date: String, location: String) {
        guard let url = URL(string: "\(eventBaseURL)/\(eventId)") else {
            self.errorMessage = "Invalid URL."
            return
        }
        let parameters: [String: Any] = [
            "title": title,
            "description": description ?? "",
            "date": date,
            "location": location
        ]
        guard let jsonData = try? JSONSerialization.data(withJSONObject: parameters) else {
            self.errorMessage = "Invalid parameters."
            return
        }
        var headers = ["Content-Type": "application/json"]
        if let token = token { headers["Authorization"] = "Bearer \(token)" }
        
        NetworkManager.shared.request(url: url,
                                      method: .put,
                                      headers: headers,
                                      body: jsonData) { (result: Result<[String: String], APIError>) in
            switch result {
            case .success(let response):
                print("Event updated: \(response)")
                self.getEvents()
            case .failure(let error):
                self.errorMessage = error.localizedDescription
            }
        }
    }
    
    /// Deletes an event by its ID.
    func deleteEvent(eventId: Int) {
        guard let url = URL(string: "\(eventBaseURL)/\(eventId)") else {
            self.errorMessage = "Invalid URL."
            return
        }
        var headers = [String: String]()
        if let token = token { headers["Authorization"] = "Bearer \(token)" }
        
        NetworkManager.shared.request(url: url,
                                      method: .delete,
                                      headers: headers,
                                      body: nil) { (result: Result<[String: String], APIError>) in
            switch result {
            case .success(let response):
                print("Event deleted: \(response)")
                self.getEvents()
            case .failure(let error):
                self.errorMessage = error.localizedDescription
            }
        }
    }
    
    /// Shares an event by its ID with a specified email.
    func shareEvent(eventId: Int, email: String) {
        guard let url = URL(string: "\(eventBaseURL)/\(eventId)/share") else {
            self.errorMessage = "Invalid URL."
            return
        }
        let parameters: [String: Any] = ["email": email]
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
                print("Event shared: \(response)")
            case .failure(let error):
                self.errorMessage = error.localizedDescription
            }
        }
    }
    
    /// Sends an RSVP status for an event.
    func attendEvent(eventId: Int, status: String) {
        guard let url = URL(string: "\(eventBaseURL)/\(eventId)/attend") else {
            self.errorMessage = "Invalid URL."
            return
        }
        let parameters: [String: Any] = ["status": status]
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
                print("RSVP successful: \(response)")
            case .failure(let error):
                self.errorMessage = error.localizedDescription
            }
        }
    }
}
