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
        NavigationStack {
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
                        .opacity(0.8)
                    
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
                    .padding(.bottom, 40)
                    .gesture(
                        DragGesture()
                            .onEnded { value in
                                // Swipe right to go to the previous slide
                                if value.translation.width > 50 {
                                    if currentSlide > 0 {
                                        withAnimation {
                                            currentSlide -= 1
                                        }
                                    }
                                }
                                // Swipe left to go to the next slide
                                else if value.translation.width < -50 {
                                    if currentSlide < slides.count - 1 {
                                        withAnimation {
                                            currentSlide += 1
                                        }
                                    }
                                }
                            }
                    )

                    // Interactive dot indicators
                    HStack {
                        ForEach(0..<slides.count, id: \.self) { index in
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
                        if currentSlide < slides.count - 1 {
                            Button(action: {
                                withAnimation {
                                    currentSlide += 1
                                }
                            }) {
                                Text("Continue")
                                    .font(.custom("Montserrat-SemiBold", size: 20))
                                    .padding()
                                    .frame(maxWidth: .infinity)
                                    .background(LinearGradient.buttonGradient)
                                    .foregroundColor(.white)
                                    .cornerRadius(10)
                                    .padding(.horizontal, 40)
                            }
                        } else {
                            NavigationLink("Get Started", value: "ChooseLoginRegisterView")
                                .font(.custom("Montserrat-SemiBold", size: 20))
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(LinearGradient.buttonGradient)
                                .foregroundColor(.white)
                                .cornerRadius(10)
                                .padding(.horizontal, 40)
                        }

                        // Skip button with NavigationLink
                        NavigationLink("Skip", value: "ChooseLoginRegisterView")
                            .font(.custom("Montserrat-Italic", size: 18))
                            .foregroundColor(.customBlue)
                    }
                }
                .padding(.bottom, 175)
                .padding(.top, 100)
            }
            .navigationDestination(for: String.self) { value in
                if value == "ChooseLoginRegisterView" {
                    ChooseLoginRegisterView()
                }
            }
        }
    }
}
