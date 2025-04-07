//
//  ChatView.swift
//  SpectrumSync
//
//  Created by Hamidat Bello on 2025-03-31.
//

import SwiftUI

// MARK: - User Chat Message Model
// This model represents a single chat message from either the user or the AI.
struct UserChatMessage: Identifiable {
    let id = UUID()
    let sender: MessageSender
    let content: String
    let timestamp: Date = Date()
}

// Enum to distinguish between a user message and an AI message.
enum MessageSender {
    case user
    case ai
}

// MARK: - Chat Message View Model
// This view model manages the list of chat messages.
class ChatMessageViewModel: ObservableObject {
    @Published var messages: [UserChatMessage] = []
    
    init() {
        // Pre-fill with some demo messages
        messages = [
            UserChatMessage(sender: .ai, content: "Hello! How can I help you today?"),
            UserChatMessage(sender: .user, content: "I need some help with my event schedule."),
            UserChatMessage(sender: .ai, content: "Sure, I'm here to help with that!")
        ]
    }
    
    /// Sends a message from the user and appends a demo AI response after a short delay.
    func sendMessage(_ text: String) {
        guard !text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else { return }
        
        let newMessage = UserChatMessage(sender: .user, content: text)
        messages.append(newMessage)
        
        // Simulate a demo AI response after a 1-second delay.
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            let response = UserChatMessage(sender: .ai, content: "Demo response to: \(text)")
            self.messages.append(response)
        }
    }
}

// MARK: - Chat View
struct ChatView: View {
    
    // Environment objects for other parts of your app (if needed)
    @EnvironmentObject var authVM: AuthViewModel
    @EnvironmentObject var eventVM: EventViewModel
    @Environment(\.dismiss) var dismiss
    
    // Our custom view model for managing chat messages.
    @StateObject private var chatMessageVM = ChatMessageViewModel()
    
    // Local state for the message input field.
    @State private var messageText = ""
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                
                // MARK: - Chat Header
                HStack {
                    // Back button placeholder.
                    Button(action: {
                        dismiss()
                    }) {
                        Image(systemName: "chevron.left")
                            .foregroundColor(.white)
                    }
                    
                    Spacer()
                    
                    // Chat title (can be the AI's name or a conversation title)
                    Text("SpectrumSync AI")
                        .font(.title.bold())
                        .foregroundColor(.white)
                    
                    Spacer()
                    
                    // Options button placeholder.
                    Button(action: {
                        // TODO: Implement options menu logic.
                    }) {
                        Image(systemName: "ellipsis")
                            .foregroundColor(.white)
                    }
                }
                .padding(.horizontal)
                .frame(height: 80)
                .background(Color.customBlue)
                
                // MARK: - Chat Messages ScrollView
                ScrollView {
                    VStack(spacing: 12) {
                        ForEach(chatMessageVM.messages) { message in
                            HStack {
                                // Align the message bubble to the left for AI messages and right for user messages.
                                if message.sender == .user {
                                    Spacer()
                                }
                                
                                Text(message.content)
                                    .padding()
                                    .background(message.sender == .user ? Color.customBlue : Color.gray.opacity(0.2))
                                    .foregroundColor(message.sender == .user ? .white : .black)
                                    .cornerRadius(10)
                                
                                if message.sender == .ai {
                                    Spacer()
                                }
                            }
                            .padding(.horizontal)
                        }
                    }
                    .padding(.vertical)
                }
                .background(Color.white)
                
                // MARK: - Message Input Field and Send Button
                HStack {
                    TextField("Ask SpectrumSync...", text: $messageText)
                        .padding(12)
                        .background(Color.gray.opacity(0.1))
                        .cornerRadius(10)
                    
                    Button(action: {
                        // Send the message and clear the input field.
                        chatMessageVM.sendMessage(messageText)
                        messageText = ""
                    }) {
                        Image(systemName: "paperplane.fill")
                            .foregroundColor(.white)
                            .padding(10)
                            .background(Color.customBlue)
                            .clipShape(Circle())
                    }
                }
                .padding()
                .background(Color.white)
            }
            .background(Color("AestheticBackground").ignoresSafeArea())
        }
        .navigationBarHidden(true)
    }
}

// MARK: - Preview
#Preview {
    ChatView()
        .environmentObject(AuthViewModel())
        .environmentObject(EventViewModel())
}
