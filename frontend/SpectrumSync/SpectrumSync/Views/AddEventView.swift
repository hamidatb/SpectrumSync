// Views/AddEventView.swift
import SwiftUI

struct AddEventView: View {
    @ObservedObject var eventVM: EventViewModel
    @State private var title = ""
    @State private var description = ""
    @State private var date = Date()
    @State private var location = ""
    
    var body: some View {
        Form {
            Section(header: Text("Event Details")) {
                TextField("Title", text: $title)
                TextField("Description", text: $description)
                DatePicker("Date", selection: $date, displayedComponents: .date)
                TextField("Location", text: $location)
            }
            Button("Create Event") {
                let formatter = ISO8601DateFormatter()
                let dateString = formatter.string(from: date)
                eventVM.createEvent(title: title, description: description, date: dateString, location: location)
            }
            .padding()
        }
        .navigationTitle("Add Event")
    }
}

struct AddEventView_Previews: PreviewProvider {
    static var previews: some View {
        AddEventView(eventVM: EventViewModel())
    }
}
