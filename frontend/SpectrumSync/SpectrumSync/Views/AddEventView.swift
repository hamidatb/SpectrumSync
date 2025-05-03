import SwiftUI

struct AddEventView: View {
    @EnvironmentObject var eventVM: EventViewModel
    @Environment(\.dismiss) var dismiss

    // MARK: - Fields
    @State private var title = ""
    @State private var description = ""
    @State private var date = Date()
    @State private var location = ""
    @State private var withWho = ""

    // Feedback
    @State private var showConfirmation = false
    @State private var showErrorToast = false
    @State private var shakeTrigger: Int = 0
    @State private var showDatePicker = false
    @State private var withWhoList: [String] = []
    @State private var currentWithWho = ""

    var body: some View {
        ZStack {
            VStack(spacing: 0) {
                VStack {
                    VStack(spacing: 24) {
                        Text("Add New Event")
                            .font(.title.bold())
                            .foregroundColor(.customDarkBlue)
                            .padding(.top)

                        VStack(alignment: .leading, spacing: 20) {
                            
                            labeledField(label: "📝 Title", content: {
                                RoundedTextField(placeholder: "Enter event title", text: $title)
                            })

                            labeledField(label: "💬 Description", content: {
                                RoundedTextField(placeholder: "Optional", text: $description)
                            })

                            labeledField(label: "📅 Date & Time", content: {
                                Button(action: { showDatePicker = true }) {
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
                            })

                            labeledField(label: "📍 Location", content: {
                                RoundedTextField(placeholder: "Where is it?", text: $location)
                            })

                            labeledField(label: "👥 With Who (Optional)", content: {
                                VStack(spacing: 8) {
                                    HStack {
                                        TextField("e.g., Mom", text: $currentWithWho)
                                            .padding(12)
                                            .background(Color.gray.opacity(0.1))
                                            .cornerRadius(12)

                                        Button(action: {
                                            let trimmed = currentWithWho.trimmingCharacters(in: .whitespaces)
                                            guard !trimmed.isEmpty else { return }
                                            withWhoList.append(trimmed)
                                            currentWithWho = ""
                                        }) {
                                            Image(systemName: "plus.circle.fill")
                                                .foregroundColor(.customBlue)
                                                .font(.system(size: 28))
                                        }
                                    }

                                    // Display the list as tags or chips
                                    if !withWhoList.isEmpty {
                                        WrapHStack(items: withWhoList) { name in
                                            Text(name)
                                                .font(.footnote)
                                                .padding(.horizontal, 12)
                                                .padding(.vertical, 6)
                                                .background(Color.customLightBlue)
                                                .foregroundColor(.white)
                                                .cornerRadius(20)
                                        }
                                    }
                                }
                            })


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
                        .padding(.horizontal, 24)
                    }
                    .padding(.top)
                }
            }

            // MARK: - Toasts
            if showConfirmation {
                toast(message: "🎉 Event Created!", color: .customLightBlue)
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

    // MARK: - Helpers

    func handleCreateEvent() {
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

        let isoDate = ISO8601DateFormatter().string(from: date)

        eventVM.createEvent(
            title: title,
            description: description,
            date: isoDate,
            location: location,
            withWho: withWhoList
        )

        withAnimation {
            showConfirmation = true
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
            dismiss()
        }
    }

    func labeledField<Content: View>(label: String, content: () -> Content) -> some View {
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

struct WrapHStack<T: Hashable, Content: View>: View {
    var items: [T]
    var content: (T) -> Content

    @State private var totalHeight: CGFloat = .zero

    var body: some View {
        GeometryReader { geometry in
            self.generateContent(in: geometry)
        }
        .frame(height: totalHeight)
    }

    private func generateContent(in geometry: GeometryProxy) -> some View {
        var width = CGFloat.zero
        var height = CGFloat.zero

        return ZStack(alignment: .topLeading) {
            ForEach(items, id: \.self) { item in
                self.content(item)
                    .padding(6)
                    .alignmentGuide(.leading, computeValue: { d in
                        if abs(width - d.width) > geometry.size.width {
                            width = 0
                            height -= d.height
                        }
                        let result = width
                        if item == items.last {
                            width = 0 // reset at the end
                        } else {
                            width -= d.width
                        }
                        return result
                    })
                    .alignmentGuide(.top, computeValue: { _ in
                        let result = height
                        if item == items.last {
                            height = 0
                        }
                        return result
                    })
            }
        }
        .background(viewHeightReader($totalHeight))
    }

    private func viewHeightReader(_ binding: Binding<CGFloat>) -> some View {
        GeometryReader { geo in
            DispatchQueue.main.async {
                binding.wrappedValue = geo.size.height
            }
            return Color.clear
        }
    }
}
