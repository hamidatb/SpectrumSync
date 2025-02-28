//
//  CalendarView.swift
//  SpectrumSync
//
//  Created by Hamidat Bello on 2025-02-28.
//

import SwiftUI
import MijickCalendarView

struct CalendarView: View {
    @State private var selectedDate: Date? = nil
    @State private var selectedRange: MDateRange? = .init()

    var body: some View {
        MCalendarView(selectedDate: $selectedDate, selectedRange: $selectedRange)
    }
}


#Preview {
    CalendarView()
}
