import SwiftUI

struct DateEventsView: View {
    let date: Date

    // MARK: - Mock Events (Replace with ViewModel later)
    let events: [Event] = previewEvents

    @State private var selectedEvent: Event?

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                Text("Events for \(date.formatted(date: .abbreviated, time: .omitted))")
                    .font(.title2.bold())
                    .foregroundColor(.customDarkBlue)
                    .padding()

                ScrollView {
                    let dayEvents = events.filter {
                        Calendar.current.isDate($0.date, inSameDayAs: date)
                    }

                    if dayEvents.isEmpty {
                        Text("No events scheduled.")
                            .foregroundColor(.gray)
                            .italic()
                            .padding(.top, 40)
                    } else {
                        VStack(spacing: 16) {
                            ForEach(dayEvents.sorted(by: { $0.date < $1.date })) { event in
                                EventCard(event: event) {
                                    selectedEvent = event
                                }
                            }
                        }
                        .padding()
                    }
                }
            }
            .navigationDestination(item: $selectedEvent) { event in
                EventDetailsView(event: event)
            }
        }
    }
}

// MARK: - Preview
#Preview {
    DateEventsView(date: isoDate("2025-04-18T00:00:00Z"))
}

// MARK: - Sample Data
private let previewEvents: [Event] = [
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

