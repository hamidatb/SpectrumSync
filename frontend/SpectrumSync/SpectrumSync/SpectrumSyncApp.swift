// SpectrumSync/SpectrumSyncApp.swift

import SwiftUI

@main
struct SpectrumSyncApp: App {
    @StateObject var authViewModel = AuthViewModel()

    var body: some Scene {
        WindowGroup {
            if authViewModel.isAuthenticated {
                HomeView(authVM: authViewModel)
                    .environmentObject(authViewModel)
            } else {
                SplashView()
                    .environmentObject(authViewModel)
            }
        }
    }
}
