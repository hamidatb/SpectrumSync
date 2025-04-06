import SwiftUI

struct CalendarView: View {
    @State private var selectedDate = Date()
    
    private let eventDates: [Date] = [
        Calendar.current.date(byAdding: .day, value: -2, to: Date())!,
        Calendar.current.date(byAdding: .day, value: 3, to: Date())!
    ]

    var body: some View {
        VStack(spacing: 24) {
            Text("View Your Events")
                .font(.system(size: 20, weight: .bold))
                .foregroundColor(.customDarkBlue)

            DatePicker(
                "",
                selection: $selectedDate,
                displayedComponents: [.date]
            )
            .datePickerStyle(.graphical)
            .accentColor(Color.blue) // change highlight color
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color.white.opacity(0.9))
                    .shadow(color: .black.opacity(0.05), radius: 10, x: 0, y: 5)
            )
            .padding(.horizontal)

            if let hasEvent = eventOn(selectedDate), hasEvent {
                Text("📌 You have an event on this day!")
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(.blue)
                    .transition(.opacity.combined(with: .scale))
            }

            Button(action: {
                // Smooth click animation
                withAnimation(.easeInOut(duration: 0.2)) {
                    print("Continue tapped on \(selectedDate)")
                }
            }) {
                Text("Continue")
                    .font(.system(size: 16, weight: .semibold))
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(12)
                    .shadow(color: .blue.opacity(0.2), radius: 6, x: 0, y: 3)
            }
            .padding(.horizontal)
        }
        .padding()
        .background(
            LinearGradient(
                gradient: Gradient(colors: [Color("AestheticBlueLight"), Color("AestheticBlueDark")]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
        )
    }

    func eventOn(_ date: Date) -> Bool? {
        eventDates.contains { Calendar.current.isDate($0, inSameDayAs: date) }
    }
}

#Preview {
    CalendarView()
}
