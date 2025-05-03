import SwiftUI

struct EventDetailsView: View {
    let event: Event
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var authVM: AuthViewModel
    @EnvironmentObject var chatVM: ChatViewModel
    @EnvironmentObject var eventVM: EventViewModel

    @State private var showDeleteConfirmation = false
    @State private var isDeleting = false
    @State private var showDeletedMessage = false
    @State private var navigateToEdit = false



    var body: some View {
        VStack(spacing: 20) {
            // MARK: - Top Event Summary
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.customBlue2)
                .overlay(
                    VStack(spacing: 0) {
                        Image(systemName: "calendar")
                            .font(.system(size: 28))
                            .foregroundColor(.customBlue3)

                        Text(event.title)
                            .font(.title2)
                            .fontWeight(.bold)
                            .multilineTextAlignment(.center)
                            .foregroundColor(.customDarkBlue)

                    }
                    .padding(.top, 80)
                    .padding(.bottom, 50)

                )
                .frame(height: 120)
                .padding(.horizontal, 30)

            // MARK: - Details Section (Aligned Right Below)
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.white)
                .overlay(
                    VStack(alignment: .leading, spacing: 20) {
                        detailRow(label: "📝 What:", value: event.title)
                        detailRow(label: "📍 Where:", value: event.location)
                        detailRow(label: "🕒 When:", value: event.date.formattedDateWithWeekday())
                        
                        if let with = event.withWho, !with.isEmpty {
                            let withText = with.joined(separator: ", ")
                            detailRow(label: "👩‍👦 With:", value: withText)
                        }

                        if let desc = event.description, !desc.isEmpty {
                            VStack(alignment: .leading, spacing: 6) {
                                Text("💬 Description:")
                                    .font(.subheadline)
                                    .fontWeight(.bold)
                                Text(desc)
                                    .font(.body)
                                    .foregroundColor(.secondary)
                            }
                        }
                    }
                    .foregroundColor(Color.customBlue3)
                    .padding()
                )
                .padding(.horizontal, 30) // Match the top card



            Spacer()

            // MARK: - Bottom Buttons
            HStack(spacing: 20) {
                Button(action: {
                    navigateToEdit = true
                }) {
                    Image(systemName: "pencil.circle.fill")
                        .font(.system(size: 36))
                        .foregroundColor(.white)
                        .background(Circle().fill(Color.customBlue).frame(width: 50, height: 50))
                        .accessibilityLabel("Edit this event")
                }

                Button(action: {
                    showDeleteConfirmation = true
                }) {
                    Image(systemName: "trash.circle.fill")
                        .font(.system(size: 36))
                        .foregroundColor(Color.customBlue)
                        .background(Circle().fill(Color.customBlue2).frame(width: 50, height: 50))
                        .accessibilityLabel("Delete this event")
                }
                .alert("Delete Event?", isPresented: $showDeleteConfirmation) {
                    Button("Delete", role: .destructive) {
                        isDeleting = true
                        Task {
                            eventVM.deleteEvent(eventId: event.id)
                            isDeleting = false
                            showDeletedMessage = true

                            // Wait a second before dismissing
                            DispatchQueue.main.asyncAfter(deadline: .now() + 1.2) {
                                dismiss()
                            }
                        }
                    }
                    Button("Cancel", role: .cancel) { }
                } message: {
                    Text("Are you sure you want to delete this event?")
                }
                   
            }
            .padding(.bottom, 20)
        }
        .padding(.top)
        .background(Color.customBlue2.ignoresSafeArea())
        .navigationTitle("")
        .navigationBarTitleDisplayMode(.inline)
        .navigationDestination(isPresented: $navigateToEdit) {
            EditEventView(event: event)
        }
        
        .overlay {
            if isDeleting {
                ZStack {
                    Color.black.opacity(0.2).ignoresSafeArea() // Dim background
                    ProgressView("Deleting...")
                        .padding()
                        .background(RoundedRectangle(cornerRadius: 12).fill(Color.white))
                        .shadow(radius: 10)
                }
                
            }
        }
        
        .overlay(
            VStack {
                if showDeletedMessage {
                    Text("🗑️ Event Deleted!")
                        .padding()
                        .background(Color.green.opacity(0.85))
                        .cornerRadius(12)
                        .foregroundColor(.white)
                        .transition(.opacity)
                        .padding(.top, 40)
                }
                Spacer()
            }
            .animation(.easeInOut(duration: 0.3), value: showDeletedMessage)
        )
    }
    

    // MARK: - Helper
    func detailRow(label: String, value: String) -> some View {
        HStack(alignment: .top) {
            Text(label)
                .fontWeight(.semibold)
            Text(value)
                .fontWeight(.medium)
                .foregroundColor(.customDarkBlue)
        }
    }
}


// MARK: - Preview
#Preview {
    EventDetailsView(event: Event(
        id: 1,
        title: "Go to Doctors",
        description: "Mom is going to take you to the doctors for a checkup after school.",
        date: isoDate("2025-02-15T14:00:00Z"),
        location: "Health Centre",
        userId: 1,
        createdAt: nil,
        withWho: ["Mom"]
    ))
    .environmentObject(EventViewModel(networkService: MockNetworkManager.shared))
    .environmentObject(AuthViewModel())
    .environmentObject(ChatViewModel())
}
