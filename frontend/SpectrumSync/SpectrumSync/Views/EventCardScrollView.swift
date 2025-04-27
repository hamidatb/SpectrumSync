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
    func formattedDateWithWeekday() -> String {
        let inputFormatter = ISO8601DateFormatter()
        let outputFormatter = DateFormatter()
        outputFormatter.dateFormat = "EEEE, MMM d, yyyy" // e.g. "Wednesday, Apr 10, 2025"

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
            VStack(spacing: 0) {
                Text("Today's Events")
                    .font(.title)
                    .fontWeight(.regular)
                    .bold()
                    .padding()
                    .foregroundColor(Color.customDarkBlue)

                ScrollView {
                    VStack(spacing: 16) {
                        // This is just for demoing the front end, this filtering logic will be moved to the backend
                        let today = Calendar.current.startOfDay(for: Date())
                        let filteredEvents = events.filter { Calendar.current.isDate($0.date, inSameDayAs: today) }

                        ForEach(filteredEvents.sorted(by: { $0.date < $1.date })) { event in
                            EventCard(event: event, onTap: {
                                withAnimation {
                                    selectedEvent = event
                                }
                            })
                        }
                    }
                    .padding()
                }
            }
            .navigationDestination(item: $selectedEvent) { event in
                EventDetailsView(event: event)
        }
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
                Text(event.date.formattedDateWithWeekday())
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
                    ForEach(withWho, id: \.self) { person in
                        Text(person)
                            .font(.body)
                            .foregroundColor(.customBlue)
                            .italic()
                    }
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

// MARK: - Preview Provider
/// Provides sample data for SwiftUI previews.
#Preview {
    EventCardScrollView(events: previewEvents)
}

// Sample events for previewing the UI in Xcode.
private let previewEvents: [Event] =  [
    Event(
        id: 1,
        title: "Therapy Session",
        description: "Weekly check-in with therapist.",
        date: isoDate("2025-04-18T10:30:00Z"),
        location: "Wellness Center",
        userId: 101,
        createdAt: nil,
        withWho: ["Mom"]
    ),
    Event(
        id: 2,
        title: "Art Class",
        description: nil,
        date: isoDate("2025-04-18T15:00:00Z"),
        location: "Room 204",
        userId: 101,
        createdAt: nil,
        withWho: nil
    ),
    Event(
        id: 3,
        title: "Playdate",
        description: "Meet with Lily at the park.",
        date: isoDate("2025-04-11T13:00:00Z"),
        location: "River Park",
        userId: 101,
        createdAt: nil,
        withWho: ["Mom"]
    )
]
