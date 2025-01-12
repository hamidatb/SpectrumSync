import SwiftUI

struct ChooseLoginRegisterView: View {
    var body: some View {
        VStack(spacing: 40) {
            Color.white
            
            // MARK: - Running
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
            
            // MARK: - Navigation Buttons Section
            VStack(spacing: 20) {
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
                
                NavigationLink(destination: LoginView()) {
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

// MARK: - Preview Provider
struct ChooseLoginRegisterView_Previews: PreviewProvider {
    static var previews: some View {
        ChooseLoginRegisterView()
            .environmentObject(AuthViewModel()) // Inject the environment object
    }
}
