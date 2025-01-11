// Views/FriendListView.swift
import SwiftUI

struct FriendListView: View {
    @ObservedObject var friendVM: FriendViewModel
    
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
        FriendListView(friendVM: FriendViewModel())
    }
}
