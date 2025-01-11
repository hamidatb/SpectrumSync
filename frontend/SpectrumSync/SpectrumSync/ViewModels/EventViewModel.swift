// SpectrumSync/ViewModels/EventViewModel.swift

import Foundation
import Combine

// Custom struct to wrap error messages and make them Identifiable
struct IdentifiableError: Identifiable {
    let id = UUID()  // Unique identifier for each error
    let message: String
}

class EventViewModel: ObservableObject {
    @Published var events: [Event] = []
    @Published var errorMessage: IdentifiableError?  // Use the custom struct instead of String

    private let baseURL = "https://spectrum-sync-backend.azurewebsites.net/api/events"
    private var token: String

    init(token: String) {
        self.token = token
        fetchEvents()
    }

    // Fetch Events
    func fetchEvents() {
        guard let url = URL(string: baseURL) else {
            print("Invalid URL")
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")

        URLSession.shared.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                if let error = error {
                    self.errorMessage = IdentifiableError(message: error.localizedDescription)
                    return
                }

                guard let data = data else {
                    self.errorMessage = IdentifiableError(message: "No data received")
                    return
                }

                do {
                    let decodedEvents = try JSONDecoder().decode([Event].self, from: data)
                    self.events = decodedEvents
                } catch {
                    self.errorMessage = IdentifiableError(message: "Failed to fetch events: \(error.localizedDescription)")
                }
            }
        }.resume()
    }

    // Create Event
    func createEvent(title: String, description: String?, date: String, location: String) {
        guard let url = URL(string: baseURL) else {
            print("Invalid URL")
            return
        }

        let parameters: [String: Any] = [
            "title": title,
            "description": description ?? "",
            "date": date,
            "location": location
        ]

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
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
                    self.errorMessage = IdentifiableError(message: error.localizedDescription)
                    return
                }

                guard let data = data else {
                    self.errorMessage = IdentifiableError(message: "No data received")
                    return
                }

                do {
                    // Assuming the backend returns a success message
                    if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                       let message = json["message"] as? String {
                        print(message)
                        self.fetchEvents() // Refresh events
                    }
                } catch {
                    self.errorMessage = IdentifiableError(message: "Failed to create event: \(error.localizedDescription)")
                }
            }
        }.resume()
    }
}
