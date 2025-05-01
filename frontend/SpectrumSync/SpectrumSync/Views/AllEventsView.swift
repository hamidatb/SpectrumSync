//
//  AllEventsView.swift
//  SpectrumSync
//
//  Created by Hamidat Bello on 2025-04-18.
//
import SwiftUI

struct AllEventsView: View {
    @EnvironmentObject var eventVM: EventViewModel

    private var events: [Event] { eventVM.events }

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
#Preview {
    AllEventsView()
        .environmentObject(EventViewModel())
}
