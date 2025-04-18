//
//  AllEventsView.swift
//  SpectrumSync
//
//  Created by Hamidat Bello on 2025-04-18.
//
import SwiftUI

struct AllEventsView: View {
    let events: [Event]

    // Extract unique days that have events
    var eventDates: Set<Date> {
        Set(events.map { Calendar.current.startOfDay(for: $0.date) })
    }

    @State private var selectedDate = Date()

    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                Text("Your Calendar")
                    .font(.title)
                    .bold()
                    .foregroundColor(.customDarkBlue)

                // Calendar Grid
                CalendarView()

                // Events for selected day
                let todaysEvents = events.filter {
                    Calendar.current.isDate($0.date, inSameDayAs: selectedDate)
                }

                ScrollView {
                    VStack(spacing: 16) {
                        if todaysEvents.isEmpty {
                            Text("No events on this day.")
                                .foregroundColor(.gray)
                        } else {
                            ForEach(todaysEvents.sorted(by: { $0.date < $1.date })) { event in
                                EventCard(event: event, onTap: {})
                            }
                        }
                    }
                    .padding()
                }
            }
            .padding(.top)
            .background(Color.paleBlueBg.ignoresSafeArea())
        }
    }
}

// MARK: - Preview Provider
/// Provides sample data for SwiftUI previews.
#Preview {
    AllEventsView(events: previewEvents)
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
        withWho: "Mom"
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
        withWho: "Mom"
    )
]
