//
//  DateEventsView.swift
//  SpectrumSync
//
//  Created by Hamidat Bello on 2025-04-18.
//

import SwiftUI

struct DateEventsView: View {
    let date: Date

    var body: some View {
        Text("Events for \(date.formatted(date: .abbreviated, time: .omitted))")
            .font(.title2)
            .padding()
    }
}

#Preview {
    DateEventsView(date: Calendar.current.date(from: DateComponents(year: 2025, month: 4, day: 18))!)
}
