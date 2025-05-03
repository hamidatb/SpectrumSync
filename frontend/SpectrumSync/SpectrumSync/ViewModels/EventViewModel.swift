// ViewModels/EventViewModel.swift
import Foundation
import Combine

/// ViewModel for handling event-related actions.
final class EventViewModel: ObservableObject {
    @Published var events: [Event] = []
    @Published var nextEvent: Event?
    @Published var invites: [Event] = []
    @Published var errorMessage: String?
    
    private let networkService: NetworkService
    private let eventBaseURL = "https://spectrum-sync-backend-g3hnfve7h3fdbuf4.canadacentral-01.azurewebsites.net/api/events"
    private var token: String?
    
    /// Initializes the EventViewModel with a NetworkService.
    /// - Parameter networkService: The network service to use (default is NetworkManager.shared).
    init(networkService: NetworkService = NetworkManager.shared) {
        self.networkService = networkService
        print("EventViewModel initialized with networkService: \(networkService)")
    }
    
    /// Sets the authentication token.
    func setToken(_ token: String) {
        self.token = token
    }
    
    /// Fetches event invitations for the authenticated user.
    func getInvites() {
        guard let url = URL(string: "\(eventBaseURL)/invites") else {
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
                               body: nil) { (result: Result<[Event], APIError>) in
            DispatchQueue.main.async {
                switch result {
                case .success(let invites):
                    self.invites = invites
                case .failure(let error):
                    self.errorMessage = error.localizedDescription
                }
            }
        }
    }
    
    /// Creates a new event.
    func createEvent(title: String, description: String?, date: String, location: String) {
        guard let url = URL(string: "\(eventBaseURL)") else {
            DispatchQueue.main.async {
                self.errorMessage = "Invalid URL."
            }
            return
        }
        let parameters: [String: Any] = [
            "title": title,
            "description": description ?? "",
            "date": date,
            "location": location
        ]
        guard let jsonData = try? JSONSerialization.data(withJSONObject: parameters) else {
            DispatchQueue.main.async {
                self.errorMessage = "Invalid parameters."
            }
            return
        }
        var headers = ["Content-Type": "application/json"]
        
        if let token = SessionManager.shared.token {
            headers["Authorization"] = "Bearer \(token)"
            print("Token is set: \(token)")
        } else {
            print("Token is nil — no Authorization header added.")
        }
        
        networkService.request(url: url,
                               method: .post,
                               headers: headers,
                               body: jsonData) { (result: Result<[String: String], APIError>) in
            DispatchQueue.main.async {
                switch result {
                case .success(let response):
                    print("Event created: \(response)")
                    self.getEvents() // Refresh events after creation.
                case .failure(let error):
                    self.errorMessage = error.localizedDescription
                }
            }
        }
    }
    
    /// Retrieves all events for the authenticated user.
    func getEvents(date: Date? = nil) {
        
        var components = URLComponents(string: eventBaseURL)
        
        if let date = date {
                let formatter = DateFormatter()
                formatter.dateFormat = "yyyy-MM-dd"
                let dateString = formatter.string(from: date)
                
                components?.queryItems = [
                    URLQueryItem(name: "date", value: dateString)
                ]
            }
        
        guard let url = components?.url else {
                DispatchQueue.main.async {
                    self.errorMessage = "Invalid URL."
                }
                return
            }
        
        
        var headers = [String: String]()
        if let token = SessionManager.shared.token {
            headers["Authorization"] = "Bearer \(token)"
            print("Token is set: \(token)")
        } else {
            print("Token is nil — no Authorization header added.")
        }
        // DEBUG PRINTS
        print("\n🔵 GET EVENTS REQUEST:")
        print("URL: \(url.absoluteString)")
        print("Method: GET")
        print("Headers: \(headers)")
        print("Body: (none)\n")
        
        networkService.request(url: url,
                               method: .get,
                               headers: headers,
                               body: nil) { (result: Result<[Event], APIError>) in
            DispatchQueue.main.async {
                switch result {
                case .success(let events):
                    self.events = events
                    print("Events fetched successfully:")
                    // TODO - remove this: Just for debugging connectivity
                    for event in events {
                        print("Event ID: \(event.id), Title: \(event.title), Date: \(event.date)")
                    }
                case .failure(let error):
                    self.errorMessage = error.localizedDescription
                    print("Failed to fetch events: \(error)")

                }
            }
        }
    }
    
    /// Gets the next upcoming event for the User
    func getNextEvent() {
        guard let url = URL(string: "\(eventBaseURL)" + "/upcomingEvent") else {
            DispatchQueue.main.async {
                self.errorMessage = "Invalid URL."
            }
            return
        }
        var headers = [String: String]()
        if let token = SessionManager.shared.token {
            headers["Authorization"] = "Bearer \(token)"
            print("Token is set: \(token)")
        } else {
            print("Token is nil — no Authorization header added.")
        }
        // DEBUG PRINTS
        print("\nGet Next Event Request:")
        print("URL: \(url.absoluteString)")
        
        networkService.request(url: url,
                               method: .get,
                               headers: headers,
                               body: nil) { (result: Result<Event, APIError>) in
            DispatchQueue.main.async {
                switch result {
                case .success(let nextEvent):
                    self.nextEvent = nextEvent
                    print("Next Event fetched successfully:")
                case .failure(let error):
                    print("Failed to fetch the next event: \(error)")

                }
            }
        }
    }
    
    /// Retrieves an event by its ID.
    func getEventById(eventId: Int, completion: @escaping (Event?) -> Void) {
        guard let url = URL(string: "\(eventBaseURL)/\(eventId)") else {
            DispatchQueue.main.async {
                self.errorMessage = "Invalid URL."
                completion(nil)
            }
            return
        }
        var headers = [String: String]()
        if let token = SessionManager.shared.token {
            headers["Authorization"] = "Bearer \(token)"
            print("Token is set: \(token)")
        } else {
            print("Token is nil — no Authorization header added.")
        }
        
        networkService.request(url: url,
                               method: .get,
                               headers: headers,
                               body: nil) { (result: Result<Event, APIError>) in
            DispatchQueue.main.async {
                switch result {
                case .success(let event):
                    completion(event)
                case .failure(let error):
                    self.errorMessage = error.localizedDescription
                    completion(nil)
                }
            }
        }
    }
    
    /// Updates an event by its ID.
    func updateEvent(eventId: Int, title: String, description: String?, date: String, location: String) {
        guard let url = URL(string: "\(eventBaseURL)/\(eventId)") else {
            DispatchQueue.main.async {
                self.errorMessage = "Invalid URL."
            }
            return
        }
        let parameters: [String: Any] = [
            "title": title,
            "description": description ?? "",
            "date": date,
            "location": location
        ]
        guard let jsonData = try? JSONSerialization.data(withJSONObject: parameters) else {
            DispatchQueue.main.async {
                self.errorMessage = "Invalid parameters."
            }
            return
        }
        var headers = ["Content-Type": "application/json"]
        if let token = token { headers["Authorization"] = "Bearer \(token)" }
        
        networkService.request(url: url,
                               method: .put,
                               headers: headers,
                               body: jsonData) { (result: Result<[String: String], APIError>) in
            DispatchQueue.main.async {
                switch result {
                case .success(let response):
                    print("Event updated: \(response)")
                    self.getEvents()
                case .failure(let error):
                    self.errorMessage = error.localizedDescription
                }
            }
        }
    }
    
    /// Deletes an event by its ID.
    func deleteEvent(eventId: Int) {
        guard let url = URL(string: "\(eventBaseURL)/\(eventId)") else {
            DispatchQueue.main.async {
                self.errorMessage = "Invalid URL."
            }
            return
        }
        var headers = [String: String]()
        if let token = SessionManager.shared.token {
            headers["Authorization"] = "Bearer \(token)"
            print("Token is set: \(token)")
        } else {
            print("Token is nil — no Authorization header added.")
        }
        
        networkService.request(url: url,
                               method: .delete,
                               headers: headers,
                               body: nil) { (result: Result<[String: String], APIError>) in
            DispatchQueue.main.async {
                switch result {
                case .success(let response):
                    print("Event deleted: \(response)")
                    self.getEvents()
                case .failure(let error):
                    self.errorMessage = error.localizedDescription
                }
            }
        }
    }
    
    /// Shares an event by its ID with a specified email.
    func shareEvent(eventId: Int, email: String) {
        guard let url = URL(string: "\(eventBaseURL)/\(eventId)/share") else {
            DispatchQueue.main.async {
                self.errorMessage = "Invalid URL."
            }
            return
        }
        let parameters: [String: Any] = ["email": email]
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
                    print("Event shared: \(response)")
                case .failure(let error):
                    self.errorMessage = error.localizedDescription
                }
            }
        }
    }
    
    /// Sends an RSVP status for an event.
    func attendEvent(eventId: Int, status: String) {
        guard let url = URL(string: "\(eventBaseURL)/\(eventId)/attend") else {
            DispatchQueue.main.async {
                self.errorMessage = "Invalid URL."
            }
            return
        }
        let parameters: [String: Any] = ["status": status]
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
                    print("RSVP successful: \(response)")
                case .failure(let error):
                    self.errorMessage = error.localizedDescription
                }
            }
        }
    }
}
