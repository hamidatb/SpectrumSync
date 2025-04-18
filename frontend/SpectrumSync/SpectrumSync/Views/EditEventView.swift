import SwiftUI

struct EditEventView: View {
    let event: Event
    @EnvironmentObject var eventVM: EventViewModel
    @Environment(\.dismiss) var dismiss

    // MARK: - Fields
    @State private var title: String
    @State private var description: String
    @State private var date: Date
    @State private var location: String
    @State private var withWhoList: [String]
    @State private var currentWithWho: String = ""

    // Feedback
    @State private var showConfirmation = false
    @State private var showErrorToast = false
    @State private var shakeTrigger: Int = 0
    @State private var showDatePicker = false

    init(event: Event) {
        self.event = event
        _title = State(initialValue: event.title)
        _description = State(initialValue: event.description ?? "")
        _date = State(initialValue: event.date)
        _location = State(initialValue: event.location)

        let people = event.withWho?
            .split(separator: ",")
            .map { $0.trimmingCharacters(in: .whitespacesAndNewlines) } ?? []

        _withWhoList = State(initialValue: people)
    }

    var body: some View {
        ZStack {
            VStack(spacing: 0) {
                ScrollView {
                    VStack(spacing: 24) {
                        Text("Edit Event")
                            .font(.title.bold())
                            .foregroundColor(.customDarkBlue)
                            .padding(.top)

                        VStack(alignment: .leading, spacing: 20) {
                            labeledField(label: "📝 Title") {
                                RoundedTextField(placeholder: "Enter event title", text: $title)
                            }

                            labeledField(label: "💬 Description") {
                                RoundedTextField(placeholder: "Optional", text: $description)
                            }

                            labeledField(label: "📅 Date & Time") {
                                Button {
                                    showDatePicker = true
                                } label: {
                                    HStack {
                                        Text(date.formatted(date: .abbreviated, time: .shortened))
                                            .foregroundColor(.customDarkBlue)
                                        Spacer()
                                        Image(systemName: "calendar")
                                            .foregroundColor(.gray)
                                    }
                                    .padding()
                                    .background(Color.gray.opacity(0.1))
                                    .cornerRadius(12)
                                }
                            }

                            labeledField(label: "📍 Location") {
                                RoundedTextField(placeholder: "Where is it?", text: $location)
                            }

                            labeledField(label: "👥 With Who (Optional)") {
                                VStack(spacing: 8) {
                                    HStack {
                                        TextField("e.g., Mom", text: $currentWithWho)
                                            .padding(12)
                                            .background(Color.gray.opacity(0.1))
                                            .cornerRadius(12)

                                        Button {
                                            let trimmed = currentWithWho.trimmingCharacters(in: .whitespaces)
                                            guard !trimmed.isEmpty else { return }
                                            withWhoList.append(trimmed)
                                            currentWithWho = ""
                                        } label: {
                                            Image(systemName: "plus.circle.fill")
                                                .foregroundColor(.customBlue)
                                                .font(.system(size: 28))
                                        }
                                    }

                                    if !withWhoList.isEmpty {
                                        WrapHStack(items: withWhoList) { name in
                                            HStack(spacing: 4) {
                                                Text(name)
                                                Image(systemName: "xmark.circle.fill")
                                                    .onTapGesture {
                                                        withWhoList.removeAll { $0 == name }
                                                    }
                                            }
                                            .font(.footnote)
                                            .padding(.horizontal, 12)
                                            .padding(.vertical, 6)
                                            .background(Color.customLightBlue)
                                            .foregroundColor(.white)
                                            .cornerRadius(20)
                                        }
                                    }
                                }
                            }

                            Button(action: handleUpdateEvent) {
                                Text("Save Changes")
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
                        .padding(.horizontal, 24)
                    }
                    .padding(.top)
                }
            }

            if showConfirmation {
                toast(message: "✅ Event Updated!", color: .customLightBlue)
            }

            if showErrorToast {
                toast(message: "Please fill in the event title.", color: .red.opacity(0.9))
            }
        }
        .sheet(isPresented: $showDatePicker) {
            VStack {
                DatePicker("Pick a date & time", selection: $date, displayedComponents: [.date, .hourAndMinute])
                    .datePickerStyle(.wheel)
                    .labelsHidden()
                    .padding()
                Button("Done") {
                    showDatePicker = false
                }
                .padding()
            }
            .presentationDetents([.fraction(0.4)])
        }
    }

    func handleUpdateEvent() {
        guard !title.trimmingCharacters(in: .whitespaces).isEmpty else {
            withAnimation {
                showErrorToast = true
                shakeTrigger += 1
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                showErrorToast = false
            }
            return
        }

        _ = ISO8601DateFormatter().string(from: date)
        let withWhoString = withWhoList.joined(separator: ", ")

        // TODO: Un-comment when API logic is available
        // eventVM.updateEvent(
        //     id: event.id,
        //     title: title,
        //     description: description,
        //     date: isoDate,
        //     location: location,
        //     withWho: withWhoString
        // )

        withAnimation {
            showConfirmation = true
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.9) {
            dismiss()
        }
    }

    func labeledField<Content: View>(label: String, @ViewBuilder content: () -> Content) -> some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(label)
                .font(.subheadline)
                .fontWeight(.semibold)
                .foregroundColor(.customDarkBlue)
                .padding(.leading, 4)
            content()
        }
    }

    func toast(message: String, color: Color) -> some View {
        VStack {
            Spacer()
            Text(message)
                .font(.subheadline)
                .padding()
                .frame(maxWidth: .infinity)
                .background(color)
                .foregroundColor(.white)
                .cornerRadius(30)
                .padding(.horizontal, 40)
                .padding(.bottom, 40)
                .transition(.move(edge: .bottom).combined(with: .opacity))
        }
        .animation(.easeOut(duration: 0.3), value: showConfirmation || showErrorToast)
    }
}


#Preview {
    let mockEventVM = EventViewModel(networkService: MockNetworkManager.shared)

    let sampleEvent = Event(
        id: 1,
        title: "Therapy Session",
        description: "Weekly check-in with therapist.",
        date: isoDate("2025-04-20T10:00:00Z"),
        location: "Wellness Center",
        userId: 101,
        createdAt: isoDate("2025-04-01T09:00:00Z"),
        withWho: "Mom"
    )

    return EditEventView(event: sampleEvent)
        .environmentObject(mockEventVM)
}
