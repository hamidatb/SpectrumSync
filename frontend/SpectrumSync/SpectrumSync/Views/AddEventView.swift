// SpectrumSync/Views/AddEventView.swift

import SwiftUI

struct AddEventView: View {
    @ObservedObject var eventViewModel: EventViewModel
    @Environment(\.presentationMode) var presentationMode

    @State private var title: String = ""
    @State private var description: String = ""
    @State private var date: Date = Date()
    @State private var location: String = ""

    var body: some View {
        Form {
            Section(header: Text("Event Details")) {
                TextField("Title", text: $title)
                TextField("Description", text: $description)
                DatePicker("Date", selection: $date, displayedComponents: .date)
                TextField("Location", text: $location)
            }

            Button(action: {
                let formatter = DateFormatter()
                formatter.dateFormat = "yyyy-MM-dd"
                let dateString = formatter.string(from: date)

                eventViewModel.createEvent(title: title, description: description, date: dateString, location: location)
                presentationMode.wrappedValue.dismiss()
            }) {
                Text("Add Event")
                    .frame(maxWidth: .infinity, alignment: .center)
            }
        }
        .navigationTitle("Add New Event")
    }
}

struct AddEventView_Previews: PreviewProvider {
    static var previews: some View {
        AddEventView(eventViewModel: EventViewModel(token: ""))
    }
}
