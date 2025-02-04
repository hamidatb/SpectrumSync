// Views/HomeView.swift
import SwiftUI

struct HomeView: View {
    @EnvironmentObject var authVM: AuthViewModel
    @EnvironmentObject var chatVM: ChatViewModel
    @EnvironmentObject var eventVM: EventViewModel
    
    // TODO: Add a logout button in the top right of this page
    var body: some View {
        NavigationView {
            VStack {
                Text("Hi \(authVM.currentUser?.username ?? "User")!")
                    .font(.title)
                    .fontWeight(.bold)
                    .padding()
                    .foregroundColor(Color.customBlue)
            }
            .onAppear {
                if let token = authVM.currentUser?.token {
                    chatVM.setToken(token)
                    eventVM.setToken(token)
                    chatVM.listAllChats()
                    eventVM.getEvents()
                }
            }
            .onChange(of: authVM.isAuthenticated) { oldValue, newValue in
                if newValue {
                    print("HomeView detected isAuthenticated change to true.")
                }
            }
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        let mockAuthVM = AuthViewModel(networkService: MockNetworkManager.shared)
        let mockChatVM = ChatViewModel(networkService: MockNetworkManager.shared)
        let mockEventVM = EventViewModel(networkService: MockNetworkManager.shared)

        return HomeView()
            .environmentObject(mockAuthVM)
            .environmentObject(mockChatVM)
            .environmentObject(mockEventVM)
    }
}
