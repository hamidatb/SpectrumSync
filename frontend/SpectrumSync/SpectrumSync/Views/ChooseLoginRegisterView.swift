import SwiftUI

struct ChooseLoginRegisterView: View {
    @EnvironmentObject var authViewModel: AuthViewModel

    var body: some View {
        ZStack {
            // Set the background color
            Color.white
                .ignoresSafeArea()
            
            VStack(spacing: 40) {
                // MARK: - Running Image
                Image("reg_login_running")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 200, height: 200)
                    .opacity(0.8)
                
                // MARK: - Gradient Text Section
                Text("Let's get started 🥳")
                    .font(.custom("Montserrat-Bold", size: 28))
                    .foregroundStyle(LinearGradient.textGradient)
                    .padding(.top, 10)
                
                VStack(spacing: 20) {
                    // Register Button
                    NavigationLink(destination: RegisterView().environmentObject(authViewModel)) {
                        Text("Register")
                            .font(.custom("Montserrat-SemiBold", size: 20))
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(LinearGradient.buttonGradient)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                            .padding(.horizontal, 40)
                    }
                    
                    // Login Button
                    NavigationLink(destination: LoginView().environmentObject(authViewModel)) {
                        Text("Login")
                            .font(.custom("Montserrat-SemiBold", size: 20))
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(LinearGradient.buttonGradient)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                            .padding(.horizontal, 40)
                            .padding(.bottom, 100)
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
