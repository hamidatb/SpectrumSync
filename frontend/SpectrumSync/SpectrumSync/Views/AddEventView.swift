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
    @State private var shakeOffset: CGFloat = 0

    // Toast flag
    @State private var showConfirmation = false
    @State private var showErrorToast = false
    @State private var shakeTrigger: Int = 0


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
                        .modifier(ShakeEffect(shakes: 3, animatableData: CGFloat(shakeTrigger)))
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
            
            if showErrorToast {
                VStack {
                    Spacer()
                    Text("Please fill in the event title.")
                        .font(.subheadline)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.red.opacity(0.80))
                        .foregroundColor(.white)
                        .cornerRadius(30)
                        .padding(.horizontal, 40)
                        .padding(.bottom, 40)
                        .transition(.move(edge: .bottom).combined(with: .opacity))
                        .animation(.easeOut(duration: 0.3), value: showErrorToast)
                }
            }

        }
        .navigationBarHidden(true)
    }

    // MARK: - Create Event Logic
    private func handleCreateEvent() {
        guard !title.trimmingCharacters(in: .whitespaces).isEmpty else {
            withAnimation {
                showErrorToast = true
                shakeTrigger += 1
            }

            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                withAnimation {
                    showErrorToast = false
                }
            }
            return
        }

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

        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            withAnimation {
                showConfirmation = false
            }
            dismiss()
        }
    }}

// MARK: - Rounded TextField
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

struct ShakeEffect: GeometryEffect {
    var shakes: Int
    var amplitude: CGFloat = 10
    var animatableData: CGFloat

    func effectValue(size: CGSize) -> ProjectionTransform {
        let translation = sin(animatableData * .pi * CGFloat(shakes)) * amplitude
        return ProjectionTransform(CGAffineTransform(translationX: translation, y: 0))
    }
}


#Preview {
    let mockEventVM = EventViewModel(networkService: MockNetworkManager.shared)
    return AddEventView()
        .environmentObject(mockEventVM)
}
