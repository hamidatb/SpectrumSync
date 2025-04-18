//
//  CustomTabBar.swift
//  SpectrumSync
//
//  Created by Hamidat Bello on 2025-02-03.
//

import SwiftUI

struct CustomTabBar: View {
    @EnvironmentObject var authVM: AuthViewModel
    @EnvironmentObject var chatVM: ChatViewModel
    @EnvironmentObject var eventVM: EventViewModel
    @EnvironmentObject var friendVM: FriendViewModel
    
    // @Binding means that the variable isn't ownder by CustomTabBar, but is being controlled by whatever parent view is calling this.
    // I'm using @State for that in the parent views
    @Binding var selectedTab: Tab // Pass the selected tab from the parent
    
    // Defines the UI layout inside the customTabBar
    var body: some View {
        
        VStack(spacing: 0) {
            //Rectangle()
                //.fill(Color.navButtonFgColour)
                //.frame(height: 3) 
            
            HStack {
                // Loop through all the tab cases and give them all a unique id
                ForEach(Tab.allCases, id: \.self) { tab in
                    // For each tab id, add a button
                    VStack {
                        Image(systemName: tab.iconName)
                        // Make the icons larger if they aren't the currently selected icons
                            .font(.system(size: selectedTab == tab ? 20 : 25))
                            .animation(.smooth(duration: 0.3), value: selectedTab) // Animate the change
                        
                        Text(tab.title)
                            .fontWeight(.bold)
                            .font(.headline)
                            .opacity(selectedTab == tab ? 1 : 0)        // Smooth fade in/out
                            .scaleEffect(selectedTab == tab ? 1 : 0)    //  Grow when selected
                            .animation(.smooth(duration: 0.3), value: selectedTab) // Animate the change
                        
                    } // endof: tabButtonVStack
                    
                    // Style each of the navigation buttons
                    .padding() // Padding inside each icons "box" (NOT MARGIN)
                    .foregroundColor(selectedTab == tab ? Color.currNavButtonFgColour : Color.navButtonFgColour) // Make the selected tab blue, the rest gray
                    
                    // Order of width, background and radius matters.
                    .frame(width: selectedTab == tab ? 120 : 55, height: 70)
                    .background(selectedTab == tab ? Color.currNavButtonBgColour : .clear ) // Give the selected tab a coloured background
                    .cornerRadius(20) // Round the background boxes to give a more button feel
                    
                    .onTapGesture {
                        // Use withAnimation for a smooth change
                        withAnimation(.easeIn(duration:0.3)) {
                            selectedTab = tab
                        }
                    } // end: onTapGesture
                }
            } // endof: HStack
            .frame(height: 100)
            .frame(minHeight: 100, maxHeight: 100)
            .frame(maxWidth: .infinity) // Make the navbar take full width
            .background(.white)
        } // endof: body
    }
}

struct CustomTabBar_Previews: PreviewProvider {
    static var previews: some View {
        // Need to use .constant to get a fixed binding to satisfy @Binding selectedTab
        CustomTabBar(selectedTab: .constant(.homeTab))
    }
}
