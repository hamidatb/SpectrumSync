// Models/NetworkManager.swift
import Foundation

/// HTTP methods used for REST requests.
enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
}

/// APIError defines the various errors that can occur during network requests.
enum APIError: Error, LocalizedError {
    case networkError(Error)
    case invalidResponse
    case noData
    case decodingError(Error)
    case httpError(Int)
    case unknown

    var errorDescription: String? {
        switch self {
        case .networkError(let error):
            return "Network error: \(error.localizedDescription)"
        case .invalidResponse:
            return "Invalid response from the server."
        case .noData:
            return "No data received from the server."
        case .decodingError(let error):
            return "Failed to decode response: \(error.localizedDescription)"
        case .httpError(let code):
            return "HTTP error with status code: \(code)"
        case .unknown:
            return "An unknown error occurred."
        }
    }
}

/// The NetworkManager singleton class that handles all network requests.
final class NetworkManager: NetworkService {
    
    static let shared = NetworkManager()
    private init() {}

    /// Makes a network request and decodes the response into the generic model T.
    /// - Parameters:
    ///   - url: The URL endpoint.
    ///   - method: The HTTP method (default is GET).
    ///   - headers: Any HTTP headers to include.
    ///   - body: Optional body data.
    ///   - completion: Completion handler that returns a result with the decoded model or an APIError.
    func request<T: Decodable>(
        url: URL,
        method: HTTPMethod = .get,
        headers: [String: String]? = nil,
        body: Data? = nil,
        completion: @escaping (Result<T, APIError>) -> Void
    ) {
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue

        // Set any provided headers.
        if let headers = headers {
            for (key, value) in headers {
                request.setValue(value, forHTTPHeaderField: key)
            }
        }

        request.httpBody = body

        // Logging the request details.
        print("[NetworkManager] \(request.httpMethod ?? "") \(request.url?.absoluteString ?? "")")

        URLSession.shared.dataTask(with: request) { data, response, error in
            // Handle network errors.
            if let error = error {
                DispatchQueue.main.async {
                    completion(.failure(.networkError(error)))
                }
                return
            }

            // Validate HTTP response status code.
            if let httpResponse = response as? HTTPURLResponse,
               !(200...299).contains(httpResponse.statusCode) {
                DispatchQueue.main.async {
                    completion(.failure(.httpError(httpResponse.statusCode)))
                }
                return
            }

            guard let data = data else {
                DispatchQueue.main.async {
                    completion(.failure(.noData))
                }
                return
            }

            // Decode the JSON data.
            do {
                let decoder = JSONDecoder()
                decoder.dateDecodingStrategy = .iso8601
                let decodedObject = try decoder.decode(T.self, from: data)
                
                DispatchQueue.main.async {
                    completion(.success(decodedObject))
                }
            } catch let decodeError {
                DispatchQueue.main.async {
                    completion(.failure(.decodingError(decodeError)))
                }
            }
        }.resume()
    }
}
