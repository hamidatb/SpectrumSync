//
//  EventCardScrollView.swift
//  SpectrumSync
//
//  Created by Hamidat Bello on 2025-04-06.
//

import SwiftUI

struct EventCardScrollView: View {
    let events: [Event]

    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                ForEach(events.sorted(by: { $0.date < $1.date })) { event in
                    EventCard(event: event)
                }
            }
            .padding()
        }
        .background(Color("AestheticBackground").ignoresSafeArea())
    }
}

struct EventCard: View {
    let event: Event

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text(formatDate(event.date))
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                Spacer()
            }

            Text(event.title)
                .font(.title3.bold())
                .foregroundColor(.customDarkBlue)


            if let description = event.description, !description.isEmpty {
                Text(description)
                    .font(.body)
                    .foregroundColor(.secondary)
            }
            
            HStack {
                Text("With:")
                    .font(.body)
                    .foregroundColor(.secondary)
                    .italic()
                if let withWho = event.withWho, !withWho.isEmpty {
                    Text("\(withWho)")
                        .font(.body)
                        .foregroundColor(.customBlue)
                    .italic()}
            }
            
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.white)
                .shadow(color: .customBlue.opacity(0.55), radius: 20, x: 0, y: 0)
        )
        .onTapGesture {
            print("TODO: Implement the full event view from clicking an event card")
        }
    }

    func formatDate(_ dateString: String) -> String {
        let inputFormatter = ISO8601DateFormatter()
        let outputFormatter = DateFormatter()
        outputFormatter.dateStyle = .medium

        if let date = inputFormatter.date(from: dateString) {
            return outputFormatter.string(from: date)
        } else {
            return dateString
        }
    }
}

#Preview {
    EventCardScrollView(events: previewEvents)
}

private let previewEvents: [Event] =  [
    Event(id: 1, title: "Therapy Session", description: "Weekly check-in with therapist.", date: "2025-04-08T10:30:00Z", location: "Wellness Center", userId: 101, createdAt: nil, withWho: "Mom"),
    Event(id: 2, title: "Art Class", description: nil, date: "2025-04-09T15:00:00Z", location: "Room 204", userId: 101, createdAt: nil, withWho: nil),
    Event(id: 3, title: "Playdate", description: "Meet with Lily at the park.", date: "2025-04-11T13:00:00Z", location: "River Park", userId: 101, createdAt: nil, withWho: "Mom"),
]
