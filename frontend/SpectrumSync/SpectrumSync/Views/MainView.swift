// Views/HomeView.swift
import SwiftUI
import Combine

struct MainView: View {
    @EnvironmentObject var authVM: AuthViewModel
    @EnvironmentObject var chatVM: ChatViewModel
    @EnvironmentObject var eventVM: EventViewModel
    @EnvironmentObject var friendVM: FriendViewModel
    @EnvironmentObject var keyboardObserver: KeyboardObserver

    // Track the selected tab
    @State private var selectedTab: Tab = .homeTab
    var shouldShowTabBar: Bool {
        !(selectedTab == .chatTab && keyboardObserver.isKeyboardVisible)
    }

    
    var body: some View {
            NavigationStack {
                GeometryReader { geometry in
                    VStack(spacing: 0) {
                        selectedTab.getView()
                            .frame(height: geometry.size.height - (shouldShowTabBar ? 100 : 0))

                        if shouldShowTabBar {
                            CustomTabBar(selectedTab: $selectedTab)
                                .frame(height: 100)
                                .environmentObject(authVM)
                                .environmentObject(chatVM)
                                .environmentObject(eventVM)
                                .environmentObject(friendVM)
                        }
                    }

                    .frame(height: geometry.size.height)
                    .edgesIgnoringSafeArea(.bottom)
                }
            }
            .ignoresSafeArea(.keyboard)
        }
}

struct MainView_Preview: PreviewProvider {
    static var previews: some View {
        let mockAuthVM = AuthViewModel(networkService: MockNetworkManager.shared)
        let mockChatVM = ChatViewModel(networkService: MockNetworkManager.shared)
        let mockEventVM = EventViewModel(networkService: MockNetworkManager.shared)
        let mockFriendVM = FriendViewModel(networkService: MockNetworkManager.shared)
        let keyboardObserver = KeyboardObserver()

        return MainView()
            .environmentObject(mockAuthVM)
            .environmentObject(mockChatVM)
            .environmentObject(mockEventVM)
            .environmentObject(mockFriendVM)
            .environmentObject(keyboardObserver)
    }
}


final class KeyboardObserver: ObservableObject {
    @Published var isKeyboardVisible: Bool = false

    private var cancellables: Set<AnyCancellable> = []

    init() {
        NotificationCenter.default.publisher(for: UIResponder.keyboardWillShowNotification)
            .sink { [weak self] _ in self?.isKeyboardVisible = true }
            .store(in: &cancellables)

        NotificationCenter.default.publisher(for: UIResponder.keyboardWillHideNotification)
            .sink { [weak self] _ in self?.isKeyboardVisible = false }
            .store(in: &cancellables)
    }
}

