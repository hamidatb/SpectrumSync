import SwiftUI

struct HomeView: View {
    @EnvironmentObject var authVM: AuthViewModel
    @EnvironmentObject var chatVM: ChatViewModel
    @EnvironmentObject var eventVM: EventViewModel
    
    @State private var showEventDetails = false
    @State private var showTodayEvents = false
    @State private var showChat = false
    
    // Dummy event data
    let nextEvent = Event(
        id: 1,
        title: "Go to Doctors",
        description: "Annual check-up with pediatrician",
        date: Calendar.current.date(from: DateComponents(year: 2025, month: 2, day: 2, hour: 9, minute: 0)) ?? Date(),
        location: "Health Centre",
        userId: 1,
        createdAt: isoDate("2025-02-01T10:00:00Z"),
        withWho: "Mom"
    )

    var body: some View {
        NavigationStack {
            VStack(spacing: 24) {
                // Top Greeting + Logo
                HStack {
                    VStack(alignment: .leading, spacing: 2) {
                        Text("Good morning,")
                            .font(.headline)
                            .fontWeight(.regular)
                            .foregroundColor(.customGray)
                        Text("\(authVM.currentUser?.username ?? "User")")
                            .font(.system(size: 32, weight: .bold))
                            .foregroundColor(Color.customDarkBlue)
                    }
                    .padding(.horizontal, 30)
                    Spacer()
                    Image("LogoDark")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 100, height: 100)
                        .opacity(0.9)
                }
                .padding(.horizontal)
                .padding(.top, 20)
                
                // Ask About Your Events card
                RoundedRectangle(cornerRadius: 20)
                    .fill(Color.customLightBlue)
                    .frame(height: 160)
                    .overlay(
                        HStack {
                            VStack(alignment: .leading, spacing: 4) {
                                Text("Ask About\nYour Events")
                                    .font(.title2)
                                    .fontWeight(.regular)
                                    .multilineTextAlignment(.leading)
                                    .lineLimit(2)
                                    .foregroundColor(Color.customDarkBlue)
                                
                                NavigationLink(destination: ChatView()) {
                                    HStack {
                                        Text("Chat")
                                            .font(.subheadline)
                                            .foregroundColor(.white)
                                        Spacer()
                                    }
                                    .padding(.horizontal, 16)
                                    .padding(.vertical, 6)
                                    .background(Color.customDarkBlue)
                                    .cornerRadius(12)
                                    .frame(width: 160)
                                }
                                .padding(.top, 5)
                                
                            }
                            .padding(.horizontal, 10)
                            Spacer()
                            Image("chatBlob")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 80, height: 80)
                                .scaleEffect(1.3)
                                .padding(.trailing, 20)
                            
                        }
                            .padding()
                    )
                    .padding(.horizontal, 30)
                
                // Blue underline bars
                HStack(spacing: 8) {
                    RoundedRectangle(cornerRadius: 8)
                        .fill(Color.customLightBlue)
                        .frame(width: 250, height: 6)
                    
                    RoundedRectangle(cornerRadius: 8)
                        .fill(Color.customLightBlue)
                        .frame(width: 60, height: 6)
                }
                
                
                // Today's date
                Text("Today is \(formattedTodayDate)")
                    .font(.system(size: 20))
                    .padding(.horizontal)
                
                
                // Event cards
                HStack(alignment: .top, spacing: 16) {
                    // Your Next Event
                    VStack(alignment: .leading, spacing:8) {
                        HStack () {
                            Text("Your Next \nEvent")
                                .font(.title3)
                                .fontWeight(.regular)
                                .foregroundColor(.customDarkBlue)
                        }
                        .frame(width: 160, height: 80)
                        .background(Color.customLightBlue)
                        .cornerRadius(16)
                        
                        NavigationLink(destination: EventDetailsView(event: nextEvent)) {
                            RoundedRectangle(cornerRadius: 16)
                                .fill(Color.customBlue2)
                                .frame(width: 160, height: 170)
                                .overlay(
                                    VStack(spacing: 6) {
                                        Image(systemName: "person.fill")
                                            .font(.system(size: 30))
                                            .foregroundColor(.black)
                                        Text(nextEvent.title)
                                            .font(.title3)
                                            .multilineTextAlignment(.center)
                                            .fontWeight(.regular)
                                        Text(formattedEventDate(event: nextEvent))
                                            .font(.system(size: 12, weight: .regular))
                                        
                                        if let with = nextEvent.withWho {
                                            Text("with \(with)")
                                                .font(.caption)
                                                .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                                                .padding(6)
                                                .padding(.horizontal, 10)
                                                .background(Color.customBlue3.opacity(0.6))
                                                .cornerRadius(12)
                                                .foregroundColor(.white)
                                        }
                                    }
                                        .padding()
                                )
                        }
                        .buttonStyle(.plain)
                    }
                    // end of "Your next event card"
                    
                    // Today's Events
                    VStack(alignment: .center, spacing: 8) {
                        NavigationLink(destination: EventCardScrollView(events: previewEvents)) {
                            VStack(spacing: 12) {
                                Text("Today’s Events")
                                    .font(.title2)
                                    .foregroundColor(.customDarkBlue)
                                    .multilineTextAlignment(.center)
                                    .frame(maxWidth: .infinity, alignment: .center)
                                
                                Image("beeRide")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(height: 130)
                                    .scaleEffect(1.4)
                            }
                            .padding()
                            .frame(width: 160, height: 260)
                            .background(Color.customBlue1)
                            .cornerRadius(16)
                        }
                        .buttonStyle(.plain)
                    }
                    
                }
                .padding(.horizontal)
                Spacer()
                
            }
        }
        .frame(height: 700)
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        let mockAuthVM = AuthViewModel(networkService: MockNetworkManager.shared)
        let mockChatVM = ChatViewModel(networkService: MockNetworkManager.shared)
        let mockEventVM = EventViewModel(networkService: MockNetworkManager.shared)

        return HomeView()
            .environmentObject(mockAuthVM)
            .environmentObject(mockChatVM)
            .environmentObject(mockEventVM)
    }
}
struct TodayEventsView: View {
    var body: some View {
        Text("List of all today's events goes here.")
            .padding()
    }
}

var formattedTodayDate: String {
    let formatter = DateFormatter()
    formatter.dateFormat = "EEEE, MMMM d"
    return formatter.string(from: Date())
}

func formattedEventDate(event: Event) -> String {
    let formatter = DateFormatter()
    formatter.dateFormat = "MMMM d • h:mm a"
    return formatter.string(from: event.date)
}


// Sample events for previewing the UI in Xcode.
private let previewEvents: [Event] =  [
    Event(
        id: 1,
        title: "Therapy Session",
        description: "Weekly check-in with therapist.",
        date: isoDate("2025-04-18T10:30:00Z"),
        location: "Wellness Center",
        userId: 101,
        createdAt: nil,
        withWho: "Mom"
    ),
    Event(
        id: 2,
        title: "Art Class",
        description: nil,
        date: isoDate("2025-04-18T15:00:00Z"),
        location: "Room 204",
        userId: 101,
        createdAt: nil,
        withWho: nil
    ),
    Event(
        id: 3,
        title: "Playdate",
        description: "Meet with Lily at the park.",
        date: isoDate("2025-04-11T13:00:00Z"),
        location: "River Park",
        userId: 101,
        createdAt: nil,
        withWho: "Mom"
    )
]
