// Views/HomeView.swift
import SwiftUI

struct MainView: View {
    @EnvironmentObject var authVM: AuthViewModel
    @EnvironmentObject var chatVM: ChatViewModel
    @EnvironmentObject var eventVM: EventViewModel
    @EnvironmentObject var friendVM: FriendViewModel
    
    // Track the selected tab
    @State private var selectedTab: Tab = .homeTab
    
    var body: some View {
        NavigationStack {
            VStack (spacing:0){
                selectedTab.getView() // dynamically load the selected view
            }
        }
    }
}

struct MainView_Preview: PreviewProvider {
    static var previews: some View {
        let mockAuthVM = AuthViewModel(networkService: MockNetworkManager.shared)
        let mockChatVM = ChatViewModel(networkService: MockNetworkManager.shared)
        let mockEventVM = EventViewModel(networkService: MockNetworkManager.shared)
        let mockFriendVM = FriendViewModel(networkService: MockNetworkManager.shared)

        return MainView()
            .environmentObject(mockAuthVM)
            .environmentObject(mockChatVM)
            .environmentObject(mockEventVM)
            .environmentObject(mockFriendVM)
    }
}
