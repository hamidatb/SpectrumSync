import SwiftUI

struct ChooseLoginRegisterView: View {
    var body: some View {
        NavigationStack {
            VStack(spacing: 40) {
                
                // MARK: - Logo Section
                // Displays the app's logo at the top, centered with some styling.
                Image("LogoDark")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 150, height: 150)
                    .padding(.top, 40)
                    .opacity(0.8)
                
                // MARK: - Gradient Text Section
                // Displays a bold, gradient-filled welcome message below the logo.
                Text("Welcome to SpectrumSync")
                    .font(.custom("Montserrat-Bold", size: 28))
                    .foregroundStyle(
                        LinearGradient(
                            gradient: Gradient(colors: [Color.customBlue, Color.customLightBlue]),
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .padding(.top, 10)
                
                Spacer() // Pushes content down, creating balanced spacing.
                
                // MARK: - Navigation Buttons Section
                // Contains buttons for Register and Login which navigate smoothly to their respective views.
                VStack(spacing: 20) {
                    // NavigationLink that smoothly transitions to RegisterView.
                    NavigationLink(destination: RegisterView()) {
                        Text("Register")
                            .font(.custom("Montserrat-SemiBold", size: 20))
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(LinearGradient.buttonGradient)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                            .padding(.horizontal, 40)
                    }
                    
                    // NavigationLink that smoothly transitions to LoginView.
                    NavigationLink(destination: LoginView()) {
                        Text("Login")
                            .font(.custom("Montserrat-SemiBold", size: 20))
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(LinearGradient.buttonGradient)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                            .padding(.horizontal, 40)
                    }
                }
                
                Spacer() // Final spacer for balanced layout at the bottom.
            }
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

// MARK: - Preview Provider
struct ChooseLoginRegisterView_Previews: PreviewProvider {
    static var previews: some View {
        ChooseLoginRegisterView()
            .environmentObject(AuthViewModel()) // Inject the environment object
    }
}
