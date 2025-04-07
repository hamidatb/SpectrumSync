//
//  AddEventView.swift
//  SpectrumSync
//
//  Created by Hamidat Bello on 2025-XX-XX.
//

import SwiftUI

struct AddEventView: View {
    @EnvironmentObject var eventVM: EventViewModel
    @Environment(\.dismiss) var dismiss

    // MARK: - Local Event Fields
    @State private var title = ""
    @State private var description = ""
    @State private var date = Date()
    @State private var location = ""

    var body: some View {
        
        CalNavigationBar(logoName: "LogoDark", onBack: ({
            dismiss()
        }))

        ScrollView {
            VStack(spacing: 20) {
                
                // MARK: - Title
                Text("Add New Event")
                    .font(.title.bold())
                    .foregroundColor(.customDarkBlue)
                    .padding(.top)
                
                // MARK: - Card Container
                VStack(spacing: 16) {
                    
                    // Title Field
                    TextField("Event Title", text: $title)
                    
                    // Description Field
                    TextField("Description", text: $description)
                    
                    // Date Picker
                    DatePicker("Date", selection: $date, displayedComponents: .date)
                        .datePickerStyle(.compact)
                        .padding()
                        .background(Color.gray.opacity(0.1))
                        .cornerRadius(12)
                    
                    // Location Field
                    TextField("Location", text: $location)
                    
                    // Create Button
                    Button(action: {
                        let formatter = ISO8601DateFormatter()
                        let dateString = formatter.string(from: date)
                        eventVM.createEvent(
                            title: title,
                            description: description,
                            date: dateString,
                            location: location
                        )
                    }) {
                        Text("Create Event")
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.customBlue)
                            .cornerRadius(12)
                    }
                    .padding(.top, 10)
                    
                }
                .padding()
                .background(Color.white)
                .cornerRadius(20)
                .shadow(color: Color.customBlue.opacity(0.15), radius: 10, x: 0, y: 5)
            }
            .padding()
        }
        .navigationBarHidden(true)
    }
}

#Preview {
    let mockEventVM = EventViewModel(networkService: MockNetworkManager.shared)
    return AddEventView()
        .environmentObject(mockEventVM)
}
