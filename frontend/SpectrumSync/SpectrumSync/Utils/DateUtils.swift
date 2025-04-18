//
//  DateUtils.swift
//  SpectrumSync
//
//  Created by Hamidat Bello on 2025-04-18.
//

import Foundation

func isoDate(_ string: String) -> Date {
    ISO8601DateFormatter().date(from: string) ?? Date()
}

extension Date {
    func formattedDateWithWeekday() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE, MMM d" // e.g., "Tuesday, Apr 16"
        return formatter.string(from: self)
    }
}
