// Views/HomeView.swift
import SwiftUI

struct HomeView: View {
    @EnvironmentObject var authVM: AuthViewModel
    @EnvironmentObject var chatVM: ChatViewModel
    @EnvironmentObject var eventVM: EventViewModel
    
    // TODO: Add a logout button in the top right of this page
    var body: some View {
        NavigationView {
            VStack {
                HStack(alignment: .top) {
                    VStack (alignment: .leading)  {
                        Text("Hi \(authVM.currentUser?.username ?? "User")")
                            .font(.title)
                            .fontWeight(.bold)
                            .foregroundColor(Color.customDarkBlue)
                        
                        Text("What would you like to do?")
                            .font(.subheadline)
                            .fontWeight(.regular)
                            .foregroundColor(Color.customDarkBlue)
                        
                        } // end of the title VStack
                    .frame(maxWidth: .infinity)
                    .frame(height: /*@START_MENU_TOKEN@*/100/*@END_MENU_TOKEN@*/)
                    
                    .padding(.top, 40)
                    //Spacer() // push SpecSync logo to the right
                    
                    Image("LogoDark")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 100, height: 100)
                        .padding(.top, 40)
                        .opacity(0.9)
                    
                    } // end of the title HStack
                .padding(.horizontal, 20)
                //.background(.red)
                
                
                // -------------- The three buttons in the middle of the page
                // Button to move the the EventView
                NavigationLink(destination: CalendarView()) {
                    Text("See Your Schedule")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding(10)
                        .frame(maxWidth: .infinity)
                        .frame(width: 300, height: 100)
                    }
                    .background(Color.customBlue)
                    .frame(maxWidth: 300, idealHeight: 300)
                    .cornerRadius(10)
                    .contentMargins(100)
                    .padding(20)


                
                // Button to move the the AddEventView
                NavigationLink(destination: AddEventView()) {
                    Text("Add An Event")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding(10)
                        .frame(maxWidth: .infinity)
                        .frame(width: 300, height: 100)

                }
                .background(Color.customBlue)
                .frame(maxWidth: 300, idealHeight: 300)
                .cornerRadius(10)
                .contentMargins(100)
                .padding(20)
                
                // Button to move to the chat view
                NavigationLink(destination: ChatView()) {
                    Text("Ask About Your Schedule")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding(10)
                        .frame(maxWidth: .infinity)
                        .frame(width: 300, height: 100)
                }
                .background(Color.customBlue)
                .frame(maxWidth: 300, idealHeight: 300)
                .cornerRadius(10)
                .contentMargins(100)
                .padding(20)


            } // endof: VStack
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment:.top)
            .background(Color.paleBlueBg)

            .onAppear {
                if let token = authVM.currentUser?.token {
                    chatVM.setToken(token)
                    eventVM.setToken(token)
                    chatVM.listAllChats()
                    eventVM.getEvents()
                }
            }
            .onChange(of: authVM.isAuthenticated) { oldValue, newValue in
                if newValue {
                    print("HomeView detected isAuthenticated change to true.")
                }
            }
        } // endof: navigationView
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
