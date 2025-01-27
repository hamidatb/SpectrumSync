// Views/FriendListView.swift
import SwiftUI

struct FriendListView: View {
    @EnvironmentObject var friendVM: FriendViewModel
    
    var body: some View {
        NavigationView {
            List(friendVM.friends) { friend in
                HStack {
                    Text(friend.username)
                    Spacer()
                    Text(friend.email)
                        .foregroundColor(.gray)
                }
            }
            .navigationTitle("Friends")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    NavigationLink("Add Friend", destination: AddFriendView(friendVM: friendVM))
                }
            }
        }
    }
}

struct FriendListView_Previews: PreviewProvider {
    static var previews: some View {
        let mockFriendVM = FriendViewModel(networkService: MockNetworkManager.shared)
        FriendListView()
            .environmentObject(mockFriendVM)
    }
}
