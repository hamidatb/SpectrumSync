//
//  EventCardScrollView.swift
//  SpectrumSync
//
//  Created by Hamidat Bello on 2025-04-06.
//

import SwiftUI

// MARK: - Date Formatting Extension
/// Extension on String to convert an ISO8601 date string into a formatted date string.
/// This helps avoid duplicating the same formatting code across different views.
extension String {
    /// Returns a formatted date string using the given date style.
    /// - Parameter style: The style to format the date (default is .medium).
    /// - Returns: A formatted date string, or the original string if conversion fails.
    func formattedDate(style: DateFormatter.Style = .medium) -> String {
        let inputFormatter = ISO8601DateFormatter()
        let outputFormatter = DateFormatter()
        outputFormatter.dateStyle = style
        
        if let date = inputFormatter.date(from: self) {
            return outputFormatter.string(from: date)
        } else {
            return self
        }
    }
}

// MARK: - Main Event Card Scroll View
/// Displays a vertically scrolling list of event cards.
/// Each card is sorted by date and tapping a card opens the full event view.
struct EventCardScrollView: View {
    let events: [Event]
    
    // State to track the currently selected event for detail view presentation.
    @State private var selectedEvent: Event? = nil
    @Environment(\.dismiss) var dismiss

    var body: some View {
        CalNavigationBar(logoName: "LogoDark", onBack: ({
            dismiss() 
        }))
        
        // ScrollView containing a vertical stack of event cards
        ScrollView {
            VStack(spacing: 16) {
                // Sort events by date and create an EventCard for each
                ForEach(events.sorted(by: { $0.date < $1.date })) { event in
                    EventCard(event: event, onTap: {
                        // Animate the selection of an event card
                        withAnimation(.spring(response: 0.4, dampingFraction: 0.7)) {
                            selectedEvent = event
                        }
                    })
                }
            }
            .padding()
        }
        // Present the full event view when an event is selected
        .sheet(item: $selectedEvent) { event in
            FullEventView(event: event, onClose: {
                selectedEvent = nil
            })
        }
        .navigationBarHidden(true)

    }
}

// MARK: - Event Card View
/// A card-style view displaying brief event details.
/// Tapping the card triggers an animation and calls the provided onTap closure.
struct EventCard: View {
    let event: Event
    var onTap: () -> Void

    // Local state to handle the press animation effect
    @State private var isPressed = false

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            // Top row with the event date
            HStack {
                Text(event.date.formattedDate())
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                Spacer()
            }
            
            // Event title
            Text(event.title)
                .font(.title3.bold())
                .foregroundColor(.customDarkBlue)
            
            // Optional event description, if available
            if let description = event.description, !description.isEmpty {
                Text(description)
                    .font(.body)
                    .foregroundColor(.secondary)
            }
            
            // Optional "with who" information if provided
            if let withWho = event.withWho, !withWho.isEmpty {
                HStack {
                    Text("With:")
                        .font(.body)
                        .foregroundColor(.secondary)
                        .italic()
                    Text(withWho)
                        .font(.body)
                        .foregroundColor(.customBlue)
                        .italic()
                }
            }
        }
        .padding()
        // Scale the card slightly when pressed for a tactile effect
        .scaleEffect(isPressed ? 0.97 : 1.0)
        .background(
            // Card background with rounded corners and a subtle shadow for depth
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.white)
                .shadow(color: .customBlue.opacity(0.45), radius: 10)
        )
        // Ensure the entire area of the card is tappable
        .contentShape(Rectangle())
        // Handle tap gesture with a brief animation and then execute the onTap action
        .onTapGesture {
            isPressed = true
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) {
                isPressed = false
                onTap()
            }
        }
    }
}

// MARK: - Full Event View
/// A detailed view for a selected event, presented as a modal.
/// Provides a minimalist layout with options to edit or delete the event.
// MARK: - Full Event View (Minimalist + Kid-Friendly)
struct FullEventView: View {
    let event: Event
    var onClose: () -> Void

    var body: some View {
        NavigationView {
            VStack(spacing: 24) {
                // Event title with a friendly bold font and soft color
                Text(event.title)
                    .font(.system(size: 24, weight: .semibold, design: .rounded))
                    .padding(.top, 30)
                    .foregroundColor(.customDarkBlue)
                    .multilineTextAlignment(.center)

                // Info container with soft background and rounded corners
                VStack(alignment: .leading, spacing: 12) {
                    HStack {
                        Image(systemName: "calendar")
                            .foregroundColor(.customBlue)
                        Text(event.date.formattedDate(style: .long))
                            .font(.body)
                            .foregroundColor(.secondary)
                    }

                    if let description = event.description, !description.isEmpty {
                        HStack(alignment: .top) {
                            Image(systemName: "note.text")
                                .foregroundColor(.customBlue)
                                .padding(.top, 2)
                            Text(description)
                                .font(.body)
                                .foregroundColor(.secondary)
                        }
                    }

                    if let withWho = event.withWho, !withWho.isEmpty {
                        HStack {
                            Image(systemName: "person.2.fill")
                                .foregroundColor(.customBlue)
                            Text("With \(withWho)")
                                .italic()
                                .foregroundColor(.secondary)
                        }
                    }
                }
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color.white)
                .cornerRadius(20)
                .shadow(color: Color.customBlue.opacity(0.1), radius: 5)

                Spacer()

                // Action buttons with soft rounded look
                HStack(spacing: 20) {
                    Button(action: {
                        print("Edit tapped")
                        // TODO: Handle edit
                    }) {
                        Label("Edit", systemImage: "pencil")
                            .frame(maxWidth: .infinity, minHeight: 80)
                    }
                    .buttonStyle(.borderedProminent)
                    .tint(.customBlue)
                    .clipShape(RoundedRectangle(cornerRadius: 12))

                    Button(action: {
                        print("Delete tapped")
                        // TODO: Handle delete
                    }) {
                        Label("Delete", systemImage: "trash")
                            .frame(maxWidth: .infinity, minHeight: 80)
                    }
                    .buttonStyle(.bordered)
                    .foregroundColor(.red)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                }
                .padding(.horizontal)

                Button("Close") {
                    onClose()
                }
                .font(.body)
                .foregroundColor(.gray)
                .padding(.top, 8)
            }
            .padding()
        }
        .navigationBarHidden(true)

    }
    
}



// MARK: - Preview Provider
/// Provides sample data for SwiftUI previews.
#Preview {
    EventCardScrollView(events: previewEvents)
}

// Sample events for previewing the UI in Xcode.
private let previewEvents: [Event] =  [
    Event(id: 1, title: "Therapy Session", description: "Weekly check-in with therapist.", date: "2025-04-08T10:30:00Z", location: "Wellness Center", userId: 101, createdAt: nil, withWho: "Mom"),
    Event(id: 2, title: "Art Class", description: nil, date: "2025-04-09T15:00:00Z", location: "Room 204", userId: 101, createdAt: nil, withWho: nil),
    Event(id: 3, title: "Playdate", description: "Meet with Lily at the park.", date: "2025-04-11T13:00:00Z", location: "River Park", userId: 101, createdAt: nil, withWho: "Mom"),
]
