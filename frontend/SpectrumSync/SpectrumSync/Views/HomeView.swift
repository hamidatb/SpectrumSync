// SpectrumSync/Views/HomeView.swift

import SwiftUI

struct HomeView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @StateObject var eventViewModel: EventViewModel

    init() {
        if let token = UserDefaults.standard.string(forKey: "jwt_token") {
            _eventViewModel = StateObject(wrappedValue: EventViewModel(token: token))
        } else {
            _eventViewModel = StateObject(wrappedValue: EventViewModel(token: ""))
        }
    }

    var body: some View {
        NavigationView {
            List(eventViewModel.events) { event in
                VStack(alignment: .leading) {
                    Text(event.title)
                        .font(.headline)
                    Text(event.description ?? "")
                        .font(.subheadline)
                    Text("Date: \(event.date)")
                        .font(.caption)
                    Text("Location: \(event.location)")
                        .font(.caption)
                }
            }
            .navigationTitle("Your Events")
            .navigationBarItems(trailing: NavigationLink(destination: AddEventView(eventViewModel: eventViewModel)) {
                Image(systemName: "plus")
            })
            .onAppear {
                eventViewModel.fetchEvents()
            }
            .alert(item: $eventViewModel.errorMessage) { error in
                Alert(title: Text("Error"), message: Text(error.message), dismissButton: .default(Text("OK")))
            }
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
            .environmentObject(AuthViewModel())
    }
}
