import SwiftUI

struct OnboardingView: View {
    // Slide data: Each tuple contains the title, description, and image name
    let slides = [
        ("Connect", "Talk with the whole family", "onboarding_connect_img"),
        ("Update", "Share and See the Schedule", "onboarding_update_img"),
        ("Manage", "See and Update the Routine", "onboarding_manage_img")
    ]
    
    @State private var currentSlide = 0  // Track the current slide
    
    var body: some View {
        ZStack {
            // Background color
            Color.white
                .ignoresSafeArea()
            
            VStack(spacing: 30) {
                // Logo at the top
                Image("LogoDark")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 150, height: 150)
                    .padding(.top, 40)
                
                Spacer()
                
                // Slide content
                VStack {
                    // Slide image
                    Image(slides[currentSlide].2)
                        .resizable()
                        .scaledToFit()
                        .frame(height: 300)
                        .padding(.bottom, 20)
                    
                    // Slide title
                    Text(slides[currentSlide].0)
                        .font(.custom("Montserrat-SemiBold", size: 28))
                        .foregroundColor(.customDarkBlue)
                        .padding(.top, 10)
                    
                    // Slide description
                    Text(slides[currentSlide].1)
                        .font(.custom("Montserrat-Regular", size: 18))
                        .foregroundColor(.customGray)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 40)
                }
                
                Spacer()
                
                // Dot indicators
                HStack {
                    ForEach(0..<slides.count, id: \.self) { index in
                        Circle()
                            .fill(index == currentSlide ? Color.customBlue : Color.customLightGray)
                            .frame(width: 10, height: 10)
                            .padding(4)
                    }
                }
                .padding(.bottom, 20)
                
                // Buttons
                VStack(spacing: 10) {
                    // Continue button
                    Button(action: {
                        if currentSlide < slides.count - 1 {
                            withAnimation {
                                currentSlide += 1
                            }
                        } else {
                            // Navigate to the next view
                            ChooseLoginRegisterView()
                        }
                    }) {
                        Text(currentSlide < slides.count - 1 ? "Continue" : "Get Started")
                            .font(.custom("Montserrat-SemiBold", size: 20))
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.customBlue)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                            .padding(.horizontal, 40)
                    }
                    
                    // Skip button
                    Button(action: {
                        // Navigate directly to the login/register view
                        ChooseLoginRegisterView()
                    }) {
                        Text("Skip")
                            .font(.custom("Montserrat-Regular", size: 18))
                            .foregroundColor(.customBlue)
                    }
                }
                .padding(.bottom, 20)
            }
        }
    }
}

struct OnboardingView_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingView()
    }
}
