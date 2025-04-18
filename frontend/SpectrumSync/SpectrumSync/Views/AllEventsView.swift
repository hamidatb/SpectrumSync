//
//  AllEventsView.swift
//  SpectrumSync
//
//  Created by Hamidat Bello on 2025-04-18.
//
import SwiftUI

struct AllEventsView: View {
    // MARK: - Mock Events (Replace with eventVM.events later)
    private let events: [Event] = [
        Event(
            id: 1,
            title: "Therapy Session",
            description: "Weekly check-in with therapist.",
            date: isoDate("2025-04-28T10:30:00Z"),
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

    // Replace this when integrating real data:
    // @EnvironmentObject var eventVM: EventViewModel
    // private var events: [Event] { eventVM.events }

    @State private var selectedDate = Date()

    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                
                VStack {
                    // Calendar Grid
                    CalendarView()
                        .frame(maxHeight: 350)

                }

                // Events from today and beyond
                let upcomingEvents = events
                    .filter { $0.date >= Calendar.current.startOfDay(for: Date()) }
                    .sorted(by: { $0.date < $1.date })
                Text("Upcoming Events")
                    .fontWeight(.regular)
                    .foregroundColor(.customBlue3)
                ScrollView {
                    VStack(spacing: 16) {
                        if upcomingEvents.isEmpty {
                            Text("You have no upcoming events.")
                                .foregroundColor(.gray)
                        } else {
                            ForEach(upcomingEvents) { event in
                                EventCard(event: event, onTap: {})
                            }
                        }
                    }
                    .padding()
                }
                .frame(height: 300)
            }
            .padding(.top)
            .background(Color.paleBlueBg.ignoresSafeArea())
        }
    }
}
// MARK: - Preview Provider
/// Provides sample data for SwiftUI previews.
#Preview {
    AllEventsView()
}
