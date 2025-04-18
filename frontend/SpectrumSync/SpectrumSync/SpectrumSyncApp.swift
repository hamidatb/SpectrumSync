// SpectrumSyncApp.swift
import SwiftUI

@main
struct SpectrumSyncApp: App {
    // Initialize ViewModels with Dependency Injection based on Environment
    @StateObject private var authViewModel: AuthViewModel
    @StateObject private var chatViewModel: ChatViewModel
    @StateObject private var eventViewModel: EventViewModel
    @StateObject private var friendViewModel: FriendViewModel
    @StateObject private var keyboardObserver = KeyboardObserver()

    @State private var isAuthenticated = false // Local state mirror

    init() {
        // Print current environment for debugging
        print("Current Environment: \(EnvironmentManager.shared.currentEnvironment)")
                
        // Determine environment and inject the appropriate NetworkService
        if EnvironmentManager.shared.currentEnvironment == .development {
            // Use MockNetworkManager for development
            _authViewModel = StateObject(wrappedValue: AuthViewModel(networkService: MockNetworkManager.shared))
            _chatViewModel = StateObject(wrappedValue: ChatViewModel(networkService: MockNetworkManager.shared))
            _eventViewModel = StateObject(wrappedValue: EventViewModel(networkService: MockNetworkManager.shared))
            _friendViewModel = StateObject(wrappedValue: FriendViewModel(networkService: MockNetworkManager.shared))
        } else {
            // Use NetworkManager for production
            _authViewModel = StateObject(wrappedValue: AuthViewModel(networkService: NetworkManager.shared))
            _chatViewModel = StateObject(wrappedValue: ChatViewModel(networkService: NetworkManager.shared))
            _eventViewModel = StateObject(wrappedValue: EventViewModel(networkService: NetworkManager.shared))
            _friendViewModel = StateObject(wrappedValue: FriendViewModel(networkService: NetworkManager.shared))
        }
    }
    
    var body: some Scene {
        WindowGroup {
            if authViewModel.isAuthenticated {
                if authViewModel.currentUser?.role == "parent" {
                    ParentMainView()
                        .environmentObject(authViewModel)
                        .environmentObject(chatViewModel)
                        .environmentObject(eventViewModel)
                        .environmentObject(friendViewModel)
                        .environmentObject(keyboardObserver)

                } else {
                    MainView()
                        .environmentObject(authViewModel)
                        .environmentObject(chatViewModel)
                        .environmentObject(eventViewModel)
                        .environmentObject(friendViewModel)
                        .environmentObject(keyboardObserver)

                }
            } else {
                SplashView()
                    .environmentObject(authViewModel)
            }
        }
    }
}
