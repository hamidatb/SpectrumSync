//
//  SessionManager.swift
//  SpectrumSync
//
//  Created by Hamidat Bello on 2025-04-26.
//

// Using this file to control the global auth variables, token, and such as a Singleton instance

import Foundation

// final so this class can't be subclassesed (since it's a singleton)
// observer to use the oberserver pattern
final class SessionManager: ObservableObject {
    static let shared = SessionManager()            // static singleton instance
    
    private init() {}       // private so have to use SessionManager.shared
    
    // published is so I can use the pub sub funtionality of the observer pattern
    @Published var currentUser: User?
    @Published var token: String?
    @Published var isAuthenticated: Bool = false
    
    func login(user: User, token: String) {
        self.currentUser = user
        self.token = token
        self.isAuthenticated = true
        print("SessionManager: User logged in with token: \(token)")
    }
    
    func logout() {
        self.currentUser = nil
        self.token = nil
        self.isAuthenticated = false
        print("SessionManager: User logged out.")
    }
}
