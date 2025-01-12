import SwiftUI

struct SplashView: View {
    // State variable to control when to navigate to the next screen
    @State private var isActive = false
    
    var body: some View {
        ZStack {
            // Background gradient
            LinearGradient.backgroundGradient
                .ignoresSafeArea()
            
            // Show the GIF if the splash is active
            if !isActive {
                GIFView(gifName: "splash")
                    .scaledToFit()
                    .transition(.opacity)
            } else {
                // Transition to the OnboardingView after the splash is done
                OnboardingView()
                    .transition(.opacity)
            }
        }
        .onAppear {
            // Get the GIF duration, then navigate after it's done
            let gifDuration = UIImage.gifDuration(data: try! Data(contentsOf: Bundle.main.url(forResource: "splash", withExtension: "gif")!))
            DispatchQueue.main.asyncAfter(deadline: .now() + gifDuration) {
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
    }
}
