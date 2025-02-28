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
    
    // computed property: title of the navbar label
    var title: String {
        switch self {
        case .homeTab: return "Home"
        case .chatTab: return "Chat"
        case .calendarTab: return "Calendar"
        case .eventTab: return "Event"
        }
    }
    
    // computed property: iconName
    var iconName: String {
        switch self {
        case .homeTab: return "house.fill"
        case .chatTab: return "message.fill"
        case .calendarTab: return "calendar"
        case .eventTab: return "clock.fill"
        }
    }
    
    // note: enums can't return Views so I have to use a function (enums use computed values)
    // method: getView to return the view of a model
    func getView() -> AnyView {
        switch self {
        case .homeTab: return AnyView(HomeView())
        case .chatTab: return AnyView(HomeView())
        case .calendarTab: return AnyView(EventListView())
        case .eventTab: return AnyView(EventListView())
        }
    }
}
