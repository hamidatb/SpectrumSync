//
//  CustomTabBar.swift
//  SpectrumSync
//
//  Created by Hamidat Bello on 2025-02-03.
//

import SwiftUI

struct CustomTabBar: View {
    // @Binding means that the variable isn't ownder by CustomTabBar, but is being controlled by whatever parent view is calling this.
    // I'm using @State for that in the parent views
    @Binding var selectedTab: Tab // Pass the selected tab from the parent
    
    // Defines the UI layout inside the customTabBar
    var body: some View {
        HStack {
            // Loop through all the tab cases and give them all a unique id
            ForEach(Tab.allCases, id: \.self) { tab in
                // For each tab id, add a button
                VStack {
                    Image(systemName: tab.iconName)
                    Text(tab.title)
                } // endof: tabButtonVStack
                .padding() // Padding inside each icons "box" (NOT MARGIN)
                .foregroundColor(selectedTab == tab ? .blue : .gray) // Make the selected tab blue, the rest gray
                .background(selectedTab == tab ? .green : .red ) // Give the selected tab a coloured background
                .cornerRadius(25) // Round the background boxes to give a more button feel
                .onTapGesture { selectedTab = tab }
            }
        } // endof: HStack
        .frame(height: 60)
        .background(.white)
    } // endof: body
}

struct CustomTabBar_Previews: PreviewProvider {
    static var previews: some View {
        // Need to use .constant to get a fixed binding to satisfy @Binding selectedTab
        CustomTabBar(selectedTab: .constant(.homeTab))
    }
}
