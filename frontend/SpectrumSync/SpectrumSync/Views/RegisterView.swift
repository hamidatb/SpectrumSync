import SwiftUI

struct RegisterView: View {
    // Inject the authentication view model from the environment.
    @EnvironmentObject var authViewModel: AuthViewModel
    
    // MARK: - State Variables for Form Data
    @State private var username: String = ""
    @State private var email: String = ""
    @State private var password: String = ""
    
    // State to control error message display.
    @State private var showError: Bool = false

    var body: some View {
        VStack(spacing: 20) {
            
            // MARK: - Form Header
            // Apply a gradient to the header text to match the app theme.
            Text("Create an Account")
                .font(.custom("Montserrat-Bold", size: 28))
                .foregroundStyle(LinearGradient.textGradient)
                .padding(.top, 20)
            
            // MARK: - Username Input Field
            TextField("Username", text: $username)
                .padding()
                .background(Color(.secondarySystemBackground))
                .cornerRadius(5)
            
            // MARK: - Email Input Field
            TextField("Email", text: $email)
                .keyboardType(.emailAddress)
                .padding()
                .background(Color(.secondarySystemBackground))
                .cornerRadius(5)
            
            // MARK: - Password Input Field
            // SecureField is used for hiding password input.
            SecureField("Password (min 6 characters)", text: $password)
                .padding()
                .background(Color(.secondarySystemBackground))
                .cornerRadius(5)
            
            // MARK: - Register Button
            Button(action: {
                // Basic email validation: ensures "@" and "." are present.
                if !email.contains("@") || !email.contains(".") {
                    authViewModel.errorMessage = "Please enter a valid email address."
                    showError = true
                    return
                }
                
                // Basic password validation: at least 6 characters.
                if password.count < 6 {
                    authViewModel.errorMessage = "Password must be at least 6 characters long."
                    showError = true
                    return
                }
                
                // Call the register function from AuthViewModel.
                authViewModel.register(username: username, email: email, password: password)
            }) {
                Text("Register")
                    .font(.custom("Montserrat-SemiBold", size: 20))
                    .frame(maxWidth: .infinity)
                    .padding()
                    // Use a dark blue background to match the theme.
                    .background(Color.customDarkBlue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                    .padding(.horizontal, 40)
            }
            
            // MARK: - Display Error Message, if any.
            if let error = authViewModel.errorMessage, showError {
                Text(error)
                    .foregroundColor(.red)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 20)
            }
            
            Spacer()
        }
        .padding()
        .navigationTitle("Register")
        .onReceive(authViewModel.$isAuthenticated) { isAuthenticated in
            // If authentication is successful, you can navigate to the home screen or another view.
            if isAuthenticated {
                // e.g., dismiss the view or navigate to HomeView.
                // Navigation code depends on your overall app navigation structure.
            }
        }
    }
}

// MARK: - Preview Provider
struct RegisterView_Previews: PreviewProvider {
    static var previews: some View {
        // Provide a sample AuthViewModel for previewing.
        RegisterView()
            .environmentObject(AuthViewModel())
    }
}
