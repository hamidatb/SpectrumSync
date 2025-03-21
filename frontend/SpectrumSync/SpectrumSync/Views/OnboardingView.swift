import SwiftUI

struct OnboardingView: View {
    // Slide data: title, description, and image name
    let slides = [
        ("Connect", "Talk with the whole family", "onboarding_connect_img"),
        ("Update", "Share and See the Schedule", "onboarding_update_img"),
        ("Manage", "See and Update the Routine", "onboarding_manage_img")
    ]
    
    @State private var currentSlide = 0  // Track the current slide index
    @GestureState private var dragOffset: CGFloat = 0  // Live drag offset
    @EnvironmentObject var authViewModel: AuthViewModel

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
                    
                    // Slide content with live drag offset
                    VStack {
                        // Slide image
                        ZStack {
                            ForEach(0..<slides.count, id: \.self) { index in
                                if index == currentSlide {
                                    Image(slides[index].2)
                                        .resizable()
                                        .scaledToFit()
                                        .frame(height: 250)
                                        .padding(.bottom, 10)
                                        .transition(.opacity)  // Smooth fade transition
                                }
                            }
                        }
                        
                        // Slide title
                        Text(slides[currentSlide].0)
                            .font(.custom("Montserrat-Bold", size: 28))
                            .foregroundColor(.customDarkBlue)
                            .padding(.top, 10)
                        
                        // Slide description
                        Text(slides[currentSlide].1)
                            .font(.custom("Montserrat-Regular", size: 15))
                            .foregroundColor(.customDarkBlue)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 40)
                    }
                    .padding(.bottom, 40)
                    // Apply the drag gesture and live offset
                    .offset(x: dragOffset)
                    .gesture(
                        DragGesture()
                            .updating($dragOffset) { value, state, _ in
                                state = value.translation.width
                            }
                            .onEnded { value in
                                // Reduced threshold for increased sensitivity
                                let threshold: CGFloat = 50
                                
                                // Drag Left – Next Slide
                                if value.translation.width < -threshold, currentSlide < slides.count - 1 {
                                    withAnimation(.easeInOut(duration: 0.3)) {
                                        currentSlide += 1
                                    }
                                }
                                // Drag Right – Previous Slide
                                else if value.translation.width > threshold, currentSlide > 0 {
                                    withAnimation(.easeInOut(duration: 0.3)) {
                                        currentSlide -= 1
                                    }
                                }
                            }
                    )

                    // Interactive dot indicators
                    HStack {
                        ForEach(0..<slides.count, id: \.self) { index in
                            Button(action: {
                                withAnimation(.easeInOut(duration: 0.3)) {
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
                        if currentSlide < slides.count - 1 {
                            Button(action: {
                                withAnimation(.easeInOut(duration: 0.3)) {
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
                            NavigationLink(destination: ChooseLoginRegisterView().environmentObject(authViewModel)) {
                                Text("Get Started")
                                    .font(.custom("Montserrat-SemiBold", size: 20))
                                    .padding()
                                    .frame(maxWidth: .infinity)
                                    .background(LinearGradient.buttonGradient)
                                    .foregroundColor(.white)
                                    .cornerRadius(10)
                                    .padding(.horizontal, 40)
                            }
                        }
                        
                        // Skip button with NavigationLink
                        NavigationLink(destination: ChooseLoginRegisterView().environmentObject(authViewModel)) {
                            Text("Skip to Login/Register")
                                .font(.custom("Montserrat-Italic", size: 15))
                                .foregroundColor(.customBlue)
                        }                    }
                }
                .padding(.bottom, 225)
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

struct OnboardingView_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingView()
    }
}
