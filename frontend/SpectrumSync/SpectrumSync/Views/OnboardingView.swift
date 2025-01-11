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
            
            VStack(spacing: 5) {
                // Logo at the top
                Image("LogoDark")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 150, height: 150)
                    .padding(.top, 40)
                    .opacity(/*@START_MENU_TOKEN@*/0.8/*@END_MENU_TOKEN@*/)
                
                Spacer()
                
                // Slide content
                VStack {
                    // Slide image
                    Image(slides[currentSlide].2)
                        .resizable()
                        .scaledToFit()
                        .frame(height: 300)
                        .padding(.bottom, 10)
                    
                    // Slide title
                    Text(slides[currentSlide].0)
                        .font(.custom("Montserrat-Bold", size: 28))
                        .foregroundColor(.customDarkBlue)
                        .padding(.top, 10)
                    
                    // Slide description
                    Text(slides[currentSlide].1)
                        .font(.custom("Montserrat-Regular", size: 18))
                        .foregroundColor(.customDarkBlue)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 40)
                }
                
                .padding(.bottom, 40)  // Control spacing between slide content and buttons

                // Interactive dot indicators
                HStack {
                    ForEach(0..<slides.count, id: \.self) { index in
                        // Add Button to make dots interactive
                        Button(action: {
                            withAnimation {
                                currentSlide = index  // Navigate to the corresponding slide
                            }
                        }) {
                            Circle()
                                .fill(index == currentSlide ? Color.customBlue : Color.customLightBlue)
                                .frame(width: 20, height: 15)
                                .padding(4)
                        }
                    }
                }
                .padding(.bottom, 20)
                
                // Buttons (Continue and Skip)
                VStack(spacing: 10) {
                    // Continue / Get Started button
                    Button(action: {
                        if currentSlide < slides.count - 1 {
                            withAnimation {
                                currentSlide += 1
                            }
                        } else {
                            // Navigate to the next view
                            // Replace 'ChooseLoginRegisterView()' with your actual navigation logic
                            print("Get Started button tapped!")
                        }
                    }) {
                        Text(currentSlide < slides.count - 1 ? "Continue" : "Get Started")
                            .font(.custom("Montserrat-SemiBold", size: 20))
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(LinearGradient.buttonGradient)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                            .padding(.horizontal, 40)
                    }
                    
                    // Skip button
                    Button(action: {
                        // Navigate directly to the login/register view
                        // Replace 'ChooseLoginRegisterView()' with your actual navigation logic
                        print("Skip button tapped!")
                    }) {
                        Text("Skip")
                            .font(.custom("Montserrat-Italic", size: 18))
                            .foregroundColor(.customBlue)
                    }
                    .padding(.bottom, 20)
                }
            }
            // Overall Zstack padding
            .padding(.bottom, 175)  // Add padding to ensure buttons stay visible
            .padding(.top, 100)  // Control spacing between slide content and buttons

        }
    }
}

struct OnboardingView_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingView()
    }
}
