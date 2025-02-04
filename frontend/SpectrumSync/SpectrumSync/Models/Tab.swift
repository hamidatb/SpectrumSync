//
//  Tab.swift
//  SpectrumSync
//
//  This model is for creating the custom naviagtion bar
//  Created by Hamidat Bello on 2025-02-03.
//

import Foundation


// Separting the cases for clear readability
// Using the CaseIterable so I can dynamically iterate over all the tabs
enum Tab: CaseIterable {
    case homeTab
    case chatTab
    case calendarTab
    case eventTab
    
    
    // Compute the properties for the icon and title
    var title: String {
        switch self {
        case .homeTab: return "Home"
        case .chatTab: return "Chat"
        case .calendarTab: return "Calendar"
        case .eventTab: return "Event"
        }
    }
    
    var iconName: String {
        switch self {
        case .homeTab: return "house.fill"
        case .chatTab: return "message.fill"
        case .calendarTab: return "calendar"
        case .eventTab: return "clock.fill"
        }
    }
}
