import SwiftUI

@main
struct SpectrumSyncApp: App {
    @StateObject var authViewModel = AuthViewModel()
    
    let appEnvironment: AppEnvironment = .development

    var body: some Scene {
        WindowGroup {
            NavigationStack {
                if authViewModel.isAuthenticated {
                    HomeView()
                        // Currently in a development environment, building relatively agnostically to the MSSQL backend
                        .environmentObject(AuthViewModel(environment: appEnvironment))
                } else {
                    SplashView()
                        .environmentObject(authViewModel)
                }
            }
        }
    }
}
