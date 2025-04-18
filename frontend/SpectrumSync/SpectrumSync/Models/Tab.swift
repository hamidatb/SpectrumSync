//
//  Tab.swift
//  SpectrumSync
//
//  This model is for creating the custom naviagtion bar
//  Created by Hamidat Bello on 2025-02-03.
//

import Foundation
import SwiftUI // need this for views


// Separting the cases for clear readability
// Using the CaseIterable so I can dynamically iterate over all the tabs
enum Tab: CaseIterable {
    case homeTab
    case chatTab
    case calendarTab
    case eventTab
    case settingsTab

    
    // computed property: title of the navbar label
    var title: String {
        switch self {
        case .homeTab: return "Home"
        case .chatTab: return "Chat"
        case .calendarTab: return "Calendar"
        case .eventTab: return "Event"
        case .settingsTab: return "Settings"
        }
    }
    
    // computed property: iconName
    var iconName: String {
        switch self {
        case .homeTab: return "house.fill"
        case .chatTab: return "message.fill"
        case .calendarTab: return "calendar"
        case .eventTab: return "clock.fill"
        case .settingsTab: return "gearshape.fill"
        }
    }
    
    // note: enums can't return Views so I have to use a function (enums use computed values)
    // method: getView to return the view of a model
    func getView() -> AnyView {
        switch self {
        case .homeTab: return AnyView(HomeView())
        case .chatTab: return AnyView(ChatView())
        case .calendarTab: return AnyView(AllEventsView())
        case .eventTab: return AnyView(AddEventView())
        case .settingsTab: return AnyView(SettingsView())
        }
    }
}

private let tabPreviewEvents: [Event] = [
    Event(
        id: 1,
        title: "Therapy Session",
        description: "Weekly check-in with therapist.",
        date: isoDate("2025-04-08T10:30:00Z"),
        location: "Wellness Center",
        userId: 101,
        createdAt: nil,
        withWho: "Mom"
    ),
    Event(
        id: 2,
        title: "Art Class",
        description: nil,
        date: isoDate("2025-04-09T15:00:00Z"),
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
