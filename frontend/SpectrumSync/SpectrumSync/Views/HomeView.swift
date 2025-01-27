// Views/HomeView.swift
import SwiftUI

struct HomeView: View {
    @EnvironmentObject var authVM: AuthViewModel
    @EnvironmentObject var chatVM: ChatViewModel
    @EnvironmentObject var eventVM: EventViewModel
    @EnvironmentObject var friendVM: FriendViewModel

    var body: some View {
        VStack {
            Text("Hi \(authVM.currentUser?.username ?? "User")!")
                .font(.title)
                .fontWeight(.bold)
                .padding()
                .foregroundColor(Color.customBlue)

            TabView {
                ChatView()
                    .tabItem { Label("Chats", systemImage: "message") }
                EventListView()
                    .tabItem { Label("Events", systemImage: "calendar") }
                FriendListView()
                    .tabItem { Label("Friends", systemImage: "person.2") }
                Button("Logout") {
                    authVM.logout()
                }
                .tabItem { Label("Logout", systemImage: "arrow.backward") }
            }
        }
        .onAppear {
            print("HomeView has received all environment objects.")
            if let token = authVM.currentUser?.token {
                chatVM.setToken(token)
                eventVM.setToken(token)
                friendVM.setToken(token)
                chatVM.listAllChats()
                eventVM.getEvents()
                friendVM.getFriendsList()
            }
        }
        .onChange(of: authVM.isAuthenticated) { oldValue, newValue in
            if newValue {
                print("HomeView detected isAuthenticated change to true.")
            }
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        let mockAuthVM = AuthViewModel(networkService: MockNetworkManager.shared)
        let mockChatVM = ChatViewModel(networkService: MockNetworkManager.shared)
        let mockEventVM = EventViewModel(networkService: MockNetworkManager.shared)
        let mockFriendVM = FriendViewModel(networkService: MockNetworkManager.shared)

        return HomeView()
            .environmentObject(mockAuthVM)
            .environmentObject(mockChatVM)
            .environmentObject(mockEventVM)
            .environmentObject(mockFriendVM)
    }
}
