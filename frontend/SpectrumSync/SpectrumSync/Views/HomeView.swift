import SwiftUI

struct HomeView: View {
    @EnvironmentObject var authVM: AuthViewModel
    @StateObject var chatVM = ChatViewModel()
    @StateObject var eventVM = EventViewModel()
    @StateObject var friendVM = FriendViewModel()

    var body: some View {
        VStack {
            Text("Hi \(authVM.currentUser?.username ?? "User")!")
                .font(.title)
                .fontWeight(.bold)
                .padding()
                .foregroundColor(Color.customBlue)

            TabView {
                ChatView(chatVM: chatVM)
                    .tabItem { Label("Chats", systemImage: "message") }
                EventListView(eventVM: eventVM)
                    .tabItem { Label("Events", systemImage: "calendar") }
                FriendListView(friendVM: friendVM)
                    .tabItem { Label("Friends", systemImage: "person.2") }
                Button("Logout") {
                    authVM.logout()
                }
                .tabItem { Label("Logout", systemImage: "arrow.backward") }
            }
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
    }
}


struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
            .environmentObject(AuthViewModel())
    }
}
