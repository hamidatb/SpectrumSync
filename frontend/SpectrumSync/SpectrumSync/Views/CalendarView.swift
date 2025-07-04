import SwiftUI

struct CalendarView: View {
    @EnvironmentObject var eventVM: EventViewModel

    private var events: [Event] { eventVM.events }

    @State private var selectedDate: Date = Date()
    @State private var currentMonthOffset = 0
    @State private var navigateToDateEvents = false
    @State private var tappedDate: Date?

    private var calendar: Calendar { Calendar.current }

    private var normalizedEventDates: Set<Date> {
        Set(eventVM.events.map { calendar.startOfDay(for: $0.date) })
    }

    private func days(for offset: Int) -> [Date] {
        let month = calendar.date(byAdding: .month, value: offset, to: Date())!
        let startOfMonth = calendar.date(from: calendar.dateComponents([.year, .month], from: month))!
        let range = calendar.range(of: .day, in: .month, for: startOfMonth)!

        return range.compactMap { day in
            calendar.date(bySetting: .day, value: day, of: startOfMonth)
        }
    }

    private func monthYearText(for offset: Int) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "LLLL yyyy"
        let date = calendar.date(byAdding: .month, value: offset, to: Date())!
        return formatter.string(from: date)
    }

    var body: some View {
        NavigationStack {
            VStack(spacing: 16) {
                // Month + Year
                Text(monthYearText(for: currentMonthOffset))
                    .font(.title2.bold())
                    .foregroundColor(.customDarkBlue)

                // Swipeable Calendar
                GeometryReader { geo in
                    TabView(selection: $currentMonthOffset) {
                        ForEach(-12...12, id: \.self) { offset in
                            monthView(for: offset)
                                .tag(offset)
                                .frame(width: geo.size.width)
                        }
                    }
                    .tabViewStyle(.page(indexDisplayMode: .never))
                }
            }
            .navigationDestination(isPresented: $navigateToDateEvents) {
                if let tapped = tappedDate {
                    DateEventsView(date: tapped)
                }
            }
        }
    }

    func monthView(for offset: Int) -> some View {
        let currentDays = days(for: offset)

        return VStack(spacing: 12) {
            let weekdays = calendar.shortWeekdaySymbols
            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 7)) {
                ForEach(weekdays, id: \.self) { day in
                    Text(day)
                        .font(.subheadline)
                        .foregroundColor(.customBlue3)
                }
            }

            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 7), spacing: 12) {
                ForEach(currentDays, id: \.self) { date in
                    VStack(spacing: 4) {
                        Text("\(calendar.component(.day, from: date))")
                            .fontWeight(calendar.isDate(date, inSameDayAs: selectedDate) ? .bold : .regular)
                            .foregroundColor(calendar.isDate(date, inSameDayAs: selectedDate) ? .white : .black)
                            .frame(width: 30, height: 30)
                            .background(
                                Circle()
                                    .fill(calendar.isDate(date, inSameDayAs: selectedDate) ? Color.customBlue : Color.clear)
                            )
                        let hasEvent = normalizedEventDates.contains(calendar.startOfDay(for: date))
                        
                        // Blue dot if event exists
                        Circle()
                            .fill(hasEvent ? Color.customBlue : Color.clear)
                            .frame(width: 6, height: 6)
                    }
                    .onTapGesture {
                        selectedDate = date
                        tappedDate = date
                        navigateToDateEvents = true
                    }
                }
            }
            .padding(.horizontal)
            .padding(.bottom)
        }
        .padding(.top)
    }
}


#Preview {
    return CalendarView()
}
