// Views/HomeView.swift
import SwiftUI

struct HomeView: View {
    @EnvironmentObject var authVM: AuthViewModel
    @EnvironmentObject var chatVM: ChatViewModel
    @EnvironmentObject var eventVM: EventViewModel
    @EnvironmentObject var friendVM: FriendViewModel
    
    @State private var selectedTab: Tab = .homeTab
    
    var body: some View {
        NavigationStack {
            VStack {
                Text("Hi \(authVM.currentUser?.username ?? "User")!")
                    .font(.title)
                    .fontWeight(.bold)
                    .padding()
                    .foregroundColor(Color.customBlue)
                
                // The home navigation bottom tab
                TabView {
                    ChatView()
                        .tabItem { Label("Home", systemImage: "house") }
                    EventListView()
                        .tabItem { Label("Chat", systemImage: "message.fill") }
                    FriendListView()
                        .tabItem { Label("Calendar", systemImage: "calendar") }
                    EventListView()
                        .tabItem { Label("Next Event", systemImage: "clock.fill") }
                    Button("Logout")
                        { authVM.logout() }
                        .tabItem { Label("Logout", systemImage: "arrow.backward") }
                }
                
                Spacer()
                CustomTabBar(selectedTab: $selectedTab)
                
                
            }
            .onAppear {
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
