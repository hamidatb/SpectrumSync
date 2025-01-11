// Views/AddFriendView.swift
import SwiftUI

struct AddFriendView: View {
    @ObservedObject var friendVM: FriendViewModel
    @State private var friendUserId: String = ""
    
    var body: some View {
        Form {
            Section(header: Text("Add Friend")) {
                TextField("Friend User ID", text: $friendUserId)
                    .keyboardType(.numberPad)
            }
            Button("Add Friend") {
                if let id = Int(friendUserId) {
                    friendVM.addFriend(friendUserId: id)
                }
            }
            .padding()
        }
        .navigationTitle("Add Friend")
    }
}

struct AddFriendView_Previews: PreviewProvider {
    static var previews: some View {
        AddFriendView(friendVM: FriendViewModel())
    }
}
