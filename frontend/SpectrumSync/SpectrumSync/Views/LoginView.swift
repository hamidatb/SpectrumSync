import SwiftUI

struct LoginView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var showError: Bool = false

    var body: some View {
        VStack(spacing: 20) {
            // Logo at the top
            Image("LogoDark")
                .resizable()
                .scaledToFit()
                .frame(width: 150, height: 150)
                .padding(.top, 40)
                .opacity(0.8)
            
            // MARK: - Form Header
            Text("Login")
                .font(.custom("Montserrat-Bold", size: 28))
                .foregroundStyle(LinearGradient.darkBlueTextGradient)
                .padding(.top, 50)

            // MARK: - Email Input
            TextField("Email", text: $email)
                .keyboardType(.emailAddress)
                .padding()
                .background(Color(.secondarySystemBackground))
                .cornerRadius(5)
                .frame(width: 300)

            // MARK: - Password Input
            SecureField("Password", text: $password)
                .padding()
                .background(Color(.secondarySystemBackground))
                .cornerRadius(5)
                .frame(width: 300)

            // MARK: - Login Button
            Button(action: {
                print("Attempting login with email: \(email)")
                authViewModel.login(email: email, password: password)
            }) {
                Text("Login")
                    .font(.custom("Montserrat-SemiBold", size: 20))
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.customDarkBlue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                    .padding(.horizontal, 30)
            }

            // MARK: - Error Message
            if let error = authViewModel.errorMessage, showError {
                Text(error)
                    .foregroundColor(.red)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 20)
                    .transition(.opacity)
            }

            Spacer()
        }
        .padding()
        .onReceive(authViewModel.$isAuthenticated) { isAuthenticated in
            if isAuthenticated {
                print("Login successful!")
            }
            showError = authViewModel.errorMessage != nil
        }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
            .environmentObject(AuthViewModel())
    }
}
