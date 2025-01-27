// Views/ChatView.swift
import SwiftUI

struct ChatView: View {
    @EnvironmentObject var chatVM: ChatViewModel

    var body: some View {
        NavigationView {
            List(chatVM.chats) { chat in
                Text(chat.chatName ?? "Chat \(chat.id)")
            }
            .navigationTitle("Chats")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        // Action to create a chat or send a message.
                    }) {
                        Image(systemName: "plus")
                    }
                }
            }
        }
    }
}


struct ChatView_Previews: PreviewProvider {
    static var previews: some View {
        let mockChatVM = ChatViewModel(networkService: MockNetworkManager.shared)
        ChatView()
            .environmentObject(mockChatVM)
    }
}
