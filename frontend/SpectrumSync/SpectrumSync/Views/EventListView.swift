// Views/EventListView.swift
import SwiftUI

struct EventListView: View {
    @ObservedObject var eventVM: EventViewModel
    
    var body: some View {
        NavigationView {
            List(eventVM.events) { event in
                VStack(alignment: .leading) {
                    Text(event.title)
                        .font(.headline)
                    if let description = event.description {
                        Text(description)
                            .font(.subheadline)
                    }
                    Text("Date: \(event.date)")
                        .font(.caption)
                }
            }
            .navigationTitle("Events")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    NavigationLink("Add Event", destination: AddEventView(eventVM: eventVM))
                }
            }
        }
    }
}

struct EventListView_Previews: PreviewProvider {
    static var previews: some View {
        EventListView(eventVM: EventViewModel())
    }
}
