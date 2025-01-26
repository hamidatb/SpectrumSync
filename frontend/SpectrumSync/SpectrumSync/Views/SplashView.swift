import SwiftUI

struct SplashView: View {
    // State variable to control when to navigate to the next screen
    @State private var isActive = false
    @EnvironmentObject var authViewModel: AuthViewModel // Use the environment object

    var body: some View {
        ZStack {
            // Background gradient
            LinearGradient.backgroundGradient
                .ignoresSafeArea()
            
            // Show the GIF if the splash is active
            if !isActive {
                GIFView(gifName: "splash_logo")
                    .scaleEffect(0.3) // Scale to 30% of original size
                    .transition(.opacity)
            } else {
                // Transition to the OnboardingView after the splash is done
                OnboardingView()
                    .environmentObject(authViewModel)
                    .transition(.opacity)
            }
        }
        .onAppear {
            // Get the GIF duration, then navigate after it's done
            let gifDuration = UIImage.gifDuration(data: try! Data(contentsOf: Bundle.main.url(forResource: "splash_logo", withExtension: "gif")!))
            // Keep the splash screen for 3 seconds
            DispatchQueue.main.asyncAfter(deadline: .now() + gifDuration + 2) {
                withAnimation(.easeInOut(duration: 1)) {
                    self.isActive = true
                }
            }
        }
    }
}

struct SplashView_Previews: PreviewProvider {
    static var previews: some View {
        SplashView()
            .environmentObject(AuthViewModel()) // Inject a mock environment object
    }
}
