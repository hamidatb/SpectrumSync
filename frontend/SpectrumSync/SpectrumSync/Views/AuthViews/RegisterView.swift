import SwiftUI

struct RegisterView: View {
    @EnvironmentObject var authViewModel: AuthViewModel

    // State for form inputs and error display
    @State private var username: String = ""
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var showError: Bool = false

    var body: some View {
        VStack(spacing: 20) {
            Spacer()
            
            // Logo at the top
            Image("LogoDark")
                .resizable()
                .scaledToFit()
                .frame(width: 150, height: 150)
                .padding(.top, 20)
                .opacity(0.8)

            // Form Header
            Text("Create an Account")
                .font(.custom("Montserrat-Bold", size: 28))
                .foregroundStyle(LinearGradient.darkBlueTextGradient)
                .padding(.top, 20)

            // Username Input Field
            TextField("Username", text: $username)
                .padding()
                .frame(maxWidth: UIScreen.main.bounds.width * 0.8)
                .background(Color(.secondarySystemBackground))
                .cornerRadius(5)
                .autocapitalization(.none)

            // Email Input Field
            TextField("Email", text: $email)
                .keyboardType(.emailAddress)
                .padding()
                .frame(maxWidth: UIScreen.main.bounds.width * 0.8)
                .background(Color(.secondarySystemBackground))
                .cornerRadius(5)
                .autocapitalization(.none)

            // Password Input Field
            SecureField("Password (min 6 characters)", text: $password)
                .padding()
                .frame(maxWidth: UIScreen.main.bounds.width * 0.8)
                .background(Color(.secondarySystemBackground))
                .cornerRadius(5)

            // Register Button
            Button(action: {
                // Perform local validations
                if username.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                    authViewModel.errorMessage = "Username cannot be empty."
                    showError = true
                    return
                }
                if username.contains(" ") {
                    authViewModel.errorMessage = "Username cannot contain spaces."
                    showError = true
                    return
                }
                if !email.contains("@") || !email.contains(".") {
                    authViewModel.errorMessage = "Please enter a valid email address."
                    showError = true
                    return
                }
                if password.count < 6 {
                    authViewModel.errorMessage = "Password must be at least 6 characters long."
                    showError = true
                    return
                }
                
                // Attempt registration
                authViewModel.register(username: username, email: email.lowercased(), password: password)
            }) {
                Text("Register")
                    .font(.custom("Montserrat-SemiBold", size: 20))
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.customDarkBlue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                    .padding(.horizontal, 25)
            }

            // Display Error Message
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
        .navigationBarBackButtonHidden(false) // Don't Hide the default back button
    }
}

struct RegisterView_Previews: PreviewProvider {
    static var previews: some View {
        RegisterView()
            .environmentObject(AuthViewModel())
    }
}
