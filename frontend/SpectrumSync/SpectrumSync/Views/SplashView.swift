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
                
                VStack(spacing: 20) {
                    Image("LogoDark")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 200, height: 200)
                        .scaleEffect(isActive ? 1 : 0.8)  // Add scaling effect
                        .animation(.easeInOut(duration: 1.5), value: isActive)

                    Text("Welcome to SpectrumSync")
                        .font(.custom("Montserrat-Bold", size: 32))
                        .foregroundColor(.customDarkBlue)
                        .multilineTextAlignment(.center)
                        .frame(maxWidth: .infinity)  // Center text horizontally
                        .padding()

                    Spacer()
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
