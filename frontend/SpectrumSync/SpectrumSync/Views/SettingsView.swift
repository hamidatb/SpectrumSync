import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var authVM: AuthViewModel
    @State private var navigateToParentInfo = false

    var body: some View {
        NavigationStack {
            ZStack {
                Color.paleBlueBg.ignoresSafeArea()

                VStack(spacing: 28) {
                    // Top Title + Blurb
                    VStack(spacing: 8) {
                        Text("Settings")
                            .font(.system(size: 28, weight: .bold))
                            .foregroundColor(.customDarkBlue)

                        Text("👋 You can log out or ask a grown-up for help.")
                            .font(.body)
                            .foregroundColor(.customBlue3)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 32)
                    }

                    // "For Parents" Button
                    Button(action: {
                        navigateToParentInfo = true
                    }) {
                        HStack {
                            Image(systemName: "person.2.fill")
                            Text("For Parents")
                                .font(.title3)
                                .fontWeight(.medium)
                        }
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.customBlue1)
                        .foregroundColor(.white)
                        .cornerRadius(16)
                        .padding(.horizontal, 40)
                    }

                    // Log Out Button
                    Button(action: {
                        authVM.logout()
                    }) {
                        HStack {
                            Image(systemName: "rectangle.portrait.and.arrow.right")
                            Text("Log Out")
                                .font(.title3)
                                .fontWeight(.medium)
                        }
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.red.opacity(0.85))
                        .foregroundColor(.white)
                        .cornerRadius(16)
                        .padding(.horizontal, 40)
                    }
                }
                .padding()
            }
            .navigationDestination(isPresented: $navigateToParentInfo) {
                ParentalSetupGuideView()
            }
        }
    }
}

#Preview {
    SettingsView()
        .environmentObject(AuthViewModel())
}
