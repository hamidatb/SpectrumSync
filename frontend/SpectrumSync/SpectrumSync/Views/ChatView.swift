import SwiftUI

// MARK: - User Chat Message Model
/// I created this model to represent a chat message, so we know who sent it (user or AI), what the content is, and when it was sent.
struct UserChatMessage: Identifiable {
    let id = UUID()
    let sender: MessageSender
    let content: String
    let timestamp: Date = Date()
}

// Enum to distinguish between a message from the user or the AI.
enum MessageSender {
    case user
    case ai
}

// MARK: - Chat Message View Model
/// This view model holds our messages. I pre-fill it with a few demo messages to illustrate the conversation.
class ChatMessageViewModel: ObservableObject {
    @Published var messages: [UserChatMessage] = []
    
    init() {
        messages = [
            UserChatMessage(sender: .ai, content: "Hello! How can I help you today?"),
            UserChatMessage(sender: .user, content: "I need some help with my event schedule."),
            UserChatMessage(sender: .ai, content: "Sure, I'm here to help with that!")
        ]
    }
    
    /// This function sends a message from the user and then simulates an AI response after 1 second.
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
    
    // These are some of the environment objects and dismiss handler I use
    @EnvironmentObject var authVM: AuthViewModel
    @EnvironmentObject var eventVM: EventViewModel
    @State private var showParentInfo = false

    @Environment(\.dismiss) var dismiss
    
    // I use my custom view model to manage the chat messages.
    @StateObject private var chatMessageVM = ChatMessageViewModel()
    
    // This holds the text for our input field.
    @State private var messageText = ""
    
    // Suggested common questions that autistic kids might have.
    private let suggestedQuestions = [
        "What do I have today?",
        "When is lunch?",
        "Who am I seeing today?"
    ]
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                
                // MARK: - Chat Header
                HStack {
                    Button(action: { dismiss() }) {
                        Image(systemName: "chevron.left")
                            .foregroundColor(.white)
                    }
                    
                    Spacer()
                    
                    Text("SpectrumSync AI")
                        .font(.title.bold())
                        .foregroundColor(.white)
                    
                    Spacer()
                    
                    Button(action: {
                        showParentInfo = true
                    }) {
                        Image(systemName: "ellipsis")
                            .foregroundColor(.white)
                    }
                    .sheet(isPresented: $showParentInfo) {
                        ParentChatInfoView()
                    }

                }
                .padding(.horizontal)
                .frame(height: 80)
                .background(Color.customBlue)
                
                // MARK: - Chat Messages with Auto-Scroll
                // I'm wrapping the messages in a ScrollViewReader so that I can programmatically scroll to the bottom.
                ScrollViewReader { proxy in
                    ScrollView {
                        VStack(spacing: 12) {
                            // I iterate through every message.
                            ForEach(chatMessageVM.messages) { message in
                                HStack {
                                    if message.sender == .user { Spacer() }
                                    
                                    // This is the chat bubble.
                                    Text(message.content)
                                        .padding()
                                        .background(message.sender == .user ? Color.customBlue : Color.gray.opacity(0.15))
                                        .foregroundColor(message.sender == .user ? .white : .black)
                                        .clipShape(RoundedRectangle(cornerRadius: 30, style: .continuous))
                                        .frame(maxWidth: UIScreen.main.bounds.width * 0.7, alignment: message.sender == .user ? .trailing : .leading)
                                        // Assign each message a unique id for scrolling
                                        .id(message.id)
                                    
                                    if message.sender == .ai { Spacer() }
                                }
                                .padding(.horizontal)
                            }
                        }
                        .padding(.vertical)
                    }
                    .background(Color.white)
                    // When a new message is added, scroll to the most recent one.
                    .onChange(of: chatMessageVM.messages.count) { _ in
                        if let lastMessage = chatMessageVM.messages.last {
                            withAnimation {
                                proxy.scrollTo(lastMessage.id, anchor: .bottom)
                            }
                        }
                    }
                }
                
                // MARK: - Suggested Questions
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 12) {
                        ForEach(suggestedQuestions, id: \.self) { question in
                            Button(action: {
                                chatMessageVM.sendMessage(question)
                            }) {
                                Text(question)
                                    .font(.subheadline)
                                    .padding(.horizontal, 16)
                                    .padding(.vertical, 10)
                                    .background(Color.customBlue.opacity(0.1))
                                    .foregroundColor(.customBlue)
                                    .clipShape(Capsule())
                            }
                        }
                    }
                    .padding(.horizontal)
                    .padding(.top, 8)
                }
                
                // MARK: - Message Input Field and Send Button
                HStack {
                    TextField("Ask SpectrumSync...", text: $messageText)
                        .padding(12)
                        .background(Color.gray.opacity(0.1))
                        .cornerRadius(10)
                    
                    Button(action: {
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
        }
        .navigationBarHidden(true)
    }
}

import SwiftUI

struct ParentChatInfoView: View {
    @Environment(\.dismiss) var dismiss

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 28) {

                    // MARK: - Title
                    Text("About This Chat")
                        .font(.system(size: 26, weight: .bold, design: .rounded))
                        .foregroundColor(.customDarkBlue)
                        .padding(.top)

                    // MARK: - Description
                    Text("This chat is a safe, limited tool designed to help your child better understand their schedule. It is built with restrictions to keep the experience secure and predictable.")
                        .font(.body)
                        .foregroundColor(.secondary)

                    // MARK: - Feature Highlights
                    VStack(alignment: .leading, spacing: 16) {
                        InfoRow(icon: "brain.head.profile", text: "100% AI-powered. No humans are behind the responses.")
                        InfoRow(icon: "bubble.left.and.exclamationmark.bubble.right", text: "Only answers simple, schedule-related questions.")
                        InfoRow(icon: "person.fill.questionmark", text: "Your child cannot message or talk to real people.")
                        InfoRow(icon: "lock.shield", text: "Conversations are filtered and private.")
                    }
                    .padding()
                    .background(Color.customLightBlue.opacity(0.30))
                    .cornerRadius(16)
                    .shadow(color: Color.customBlue.opacity(0.08), radius: 6)

                    // MARK: - Website
                    VStack(alignment: .leading, spacing: 8) {
                        Text("For full parental controls or support, please visit:")
                            .font(.subheadline)
                            .foregroundColor(.secondary)

                        Text("www.spectrumsync.app")
                            .font(.body.bold())
                            .foregroundColor(.customBlue)
                            .underline()
                    }

                    Spacer(minLength: 40)
                }
                .padding(.horizontal, 24)
            }
            .navigationTitle("Parental Chat Info")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Done") {
                        dismiss()
                    }
                    .font(.body)
                    .foregroundColor(.customBlue)
                }
            }
        }
    }
}

// MARK: - Reusable Info Row with Icon
struct InfoRow: View {
    let icon: String
    let text: String

    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            Image(systemName: icon)
                .foregroundColor(.customBlue)
                .font(.title3)

            Text(text)
                .font(.body)
                .foregroundColor(.primary)
        }
    }
}



// MARK: - Preview
#Preview {
    ChatView()
        .environmentObject(AuthViewModel())
        .environmentObject(EventViewModel())
}
