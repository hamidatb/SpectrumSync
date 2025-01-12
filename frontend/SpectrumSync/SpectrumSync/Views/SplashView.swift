import SwiftUI

struct SplashView: View {
    // State variable to control when to navigate to the next screen.
    @State private var isActive = false

    var body: some View {
        ZStack {
            // Gradient background
            LinearGradient.backgroundGradient
                .ignoresSafeArea()
            
            // Conditional navigation logic
            if isActive {
                // Show the onboarding view after the splash is displayed
                OnboardingView()
                    .transition(.opacity)  // Smooth fade-in transition
                    .animation(.easeInOut(duration: 1.5), value: isActive)

            } else {
                GeometryReader { geometry in
                    VStack {
                        Spacer()

                        // Center the logo exactly in the middle of the screen
                        Image("LogoDark")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 400, height: 400)
                            .position(x: geometry.size.width / 2, y: geometry.size.height / 2)
                            .scaleEffect(isActive ? 1 : 0.8)
                            .animation(.easeInOut(duration: 1.5), value: isActive)

                        Spacer()
                    }
                }
                .transition(.opacity)  // Smooth fade-out transition
                .onAppear {
                    // Delay for 3 seconds before moving to the next view
                    DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                        withAnimation(.easeInOut(duration: 1.5)) {
                            self.isActive = true
                        }
                    }
                }
            }
        }
    }
}

struct SplashView_Previews: PreviewProvider {
    static var previews: some View {
        SplashView()
    }
}
