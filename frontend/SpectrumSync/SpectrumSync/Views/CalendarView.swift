//
//  CustomDayView.swift
//  SpectrumSync
//
//  Created by Hamidat Bello on 2025-02-28.
//

import SwiftUI
import MijickCalendarView

struct CalendarView: View {
    @State private var selectedDate: Date?
    
    var body: some View {
        ZStack {
            createContent()
        }
    }
}
private extension CalendarView {
    func createContent() -> some View {
        VStack(spacing: 0) {
            Spacer().frame(height: 32)
            createCalendarView()
        }
    }
}

private extension CalendarView {

    func createCalendarView() -> some View {
        MCalendarView(selectedDate: $selectedDate, selectedRange: nil, configBuilder: configureCalendar)
            .padding(.horizontal, margins)
    }
}
private extension CalendarView {
    func configureCalendar(_ config: CalendarConfig) -> CalendarConfig {
        config
            .daysHorizontalSpacing(9)
            .daysVerticalSpacing(19)
            .monthsBottomPadding(16)
            .monthsTopPadding(42)
    }
}
// private extension CalendarView {
   //  func buildDayView(_ date: Date, _ isCurrentMonth: Bool, selectedDate: Binding<Date?>?, range: Binding<MDateRange?>?) -> DV.ColoredRectangle {
        // return .init(date: date, color: getDateColor(date), isCurrentMonth: isCurrentMonth, selectedDate: selectedDate, selectedRange: nil)
    // }
// }

private extension CalendarView {
    func onContinueButtonTap() { }
    func getDateColor(_ date: Date) -> Color? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "d"
        
        let day = Int(dateFormatter.string(from: date)) ?? 0
        if day % 5 == 0 { return .red }
        if day % 9 == 0 { return .orange}
        if day % 11 == 0  { return .green }
        return nil
    }
}

// MARK: - Modifiers
fileprivate let margins: CGFloat = 28

// MARK: - Preview
#Preview {
    CalendarView()
}
