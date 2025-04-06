//
//  ChatView.swift
//  SpectrumSync
//
//  Created by Hamidat Bello on 2025-03-31.
//

import SwiftUI

struct ChatView: View {
    
    @EnvironmentObject var authVM: AuthViewModel
    @EnvironmentObject var chatVM: ChatViewModel
    @EnvironmentObject var eventVM: EventViewModel
    
    // Local state for the message input field
    @State private var messageText = ""
    
    
    
    var body: some View {
        NavigationView {
            VStack {
                // Add the chat header (back arrow, elipses later)
                
                // MARK: The chat header
                HStack(alignment: .center) {
                    Button(action: {
                        // YAYYY the button shows up
                        // TODO: ADD Actual logic here
                    }) {
                        Image(systemName: "chevron.left")
                            .foregroundColor(.white)
                    }
                    
                    Text("UserName")
                        .font(.title)
                        .foregroundColor(.white)
                        .padding(.horizontal, 50)
                    
                    // Just adding space before the elipses
                    Spacer()
                    
                    Button(action: {
                        // TODO: ADD Actual logic here

                    }) {
                        Image(systemName: "ellipsis")
                            .foregroundColor(.white)
                    }
                    .padding()
                }
                .background(Color.customBlue)
                .frame(height:40)
                .frame(maxWidth: .infinity)
                .padding(.horizontal, 20)

                
            // MARK: The chat messages scrollview
                ScrollView {
                    VStack(alignment: .leading) {
                        Text("ScrollView PlaceHolder")
                    }
                    .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/)
                }
                .padding(.top, 20)
                .background(.white)
                .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/)
                
            } // end of the main VStack
            .padding(.top, 10)
            .background(.red)
        } // end of Naviagation View
        .background(.purple)
    } // end of body
}

#Preview {
    ChatView()
}
