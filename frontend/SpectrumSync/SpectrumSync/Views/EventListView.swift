// Views/EventListView.swift
import SwiftUI

struct EventListView: View {
    @EnvironmentObject var eventVM: EventViewModel
    
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
            .navigationTitle("Event Calendar View")
            .toolbar {
                // TODO: implement the toolbar
            }
        }
    }
}

struct EventListView_Previews: PreviewProvider {
    static var previews: some View {
        let mockEventVM = EventViewModel(networkService: MockNetworkManager.shared)
        EventListView()
            .environmentObject(mockEventVM)
    }
}
