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

    // Toast flag
    @State private var showConfirmation = false

    var body: some View {
        ZStack {
            VStack(spacing: 0) {
                // MARK: - Custom Nav Bar
                CalNavigationBar(logoName: "LogoDark", onBack: {
                    dismiss()
                })

                // MARK: - Form
                ScrollView {
                    VStack(spacing: 24) {

                        Text("Add New Event")
                            .font(.title.bold())
                            .foregroundColor(.customDarkBlue)
                            .padding(.top)

                        VStack(spacing: 16) {
                            RoundedTextField(placeholder: "Event Title", text: $title)
                            RoundedTextField(placeholder: "Description", text: $description)

                            DatePicker("Date", selection: $date, displayedComponents: .date)
                                .datePickerStyle(.compact)
                                .padding()
                                .background(Color.gray.opacity(0.1))
                                .cornerRadius(12)

                            RoundedTextField(placeholder: "Location", text: $location)

                            Button(action: handleCreateEvent) {
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
                        .shadow(color: Color.customBlue.opacity(0.35), radius: 40, x: 0, y: 5)
                    }
                    .padding(.horizontal, 24)
                    .padding(.top)
                }
            }

            // MARK: - Confirmation Toast
            if showConfirmation {
                VStack {
                    Spacer()
                    Text("Event Created!")
                        .font(.headline)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.customLightBlue)
                        .foregroundColor(.white)
                        .cornerRadius(30)
                        .padding(.horizontal, 40)
                        .padding(.bottom, 40)
                        .transition(.move(edge: .bottom).combined(with: .opacity))
                        .animation(.easeOut(duration: 0.3), value: showConfirmation)
                }
            }
        }
        .navigationBarHidden(true)
    }

    // MARK: - Create Event Logic
    private func handleCreateEvent() {
        let formatter = ISO8601DateFormatter()
        let dateString = formatter.string(from: date)

        eventVM.createEvent(
            title: title,
            description: description,
            date: dateString,
            location: location
        )

        withAnimation {
            showConfirmation = true
        }

        // Hide toast and dismiss view after short delay
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            withAnimation {
                showConfirmation = false
            }
            dismiss()
        }
    }
}

// MARK: - Reusable Rounded TextField
struct RoundedTextField: View {
    var placeholder: String
    @Binding var text: String

    var body: some View {
        TextField(placeholder, text: $text)
            .padding(12)
            .background(Color.gray.opacity(0.1))
            .cornerRadius(12)
    }
}

#Preview {
    let mockEventVM = EventViewModel(networkService: MockNetworkManager.shared)
    return AddEventView()
        .environmentObject(mockEventVM)
}
