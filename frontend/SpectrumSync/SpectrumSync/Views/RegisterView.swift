import SwiftUI

struct RegisterView: View {
    // Inject the authentication view model from the environment.
    @EnvironmentObject var authViewModel: AuthViewModel
    @Environment(\.presentationMode) var presentationMode

    // MARK: - State Variables for Form Data and Visual Feedback
    @State private var username: String = ""
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var showError: Bool = false
    @State private var showSuccessAlert: Bool = false

    var body: some View {
        VStack(spacing: 20) {
            Spacer()
            // MARK: - Form Header with Gradient Styling
            Text("Create an Account")
                .font(.custom("Montserrat-Bold", size: 28))
                .foregroundStyle(LinearGradient.textGradient)
                .padding(.top, 20)
            
            // MARK: - Username Input Field
            TextField("Username", text: $username)
                .padding()
                .frame(width: 300)
                .background(Color(.secondarySystemBackground))
                .cornerRadius(5)
            
            // MARK: - Email Input Field
            TextField("Email", text: $email)
                .keyboardType(.emailAddress)
                .padding()
                .frame(width: 300)
                .background(Color(.secondarySystemBackground))
                .cornerRadius(5)
            
            // MARK: - Password Input Field
            SecureField("Password (min 6 characters)", text: $password)
                .padding()
                .frame(width: 300)
                .background(Color(.secondarySystemBackground))
                .cornerRadius(5)
            
            // MARK: - Register Button
            Button(action: {
                // Validate username
                if username.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                    authViewModel.errorMessage = "Username cannot be empty."
                    showError = true
                    print("Registration failed: username is empty.")
                    return
                }
                
                if username.contains(" ") {
                    authViewModel.errorMessage = "Username cannot contain spaces."
                    showError = true
                    print("Registration failed: username contains spaces.")
                    return
                }
                
                // Validate email format
                if !email.contains("@") || !email.contains(".") {
                    authViewModel.errorMessage = "Please enter a valid email address."
                    showError = true
                    print("Registration failed: invalid email format.")
                    return
                }
                
                // Validate password length
                if password.count < 6 {
                    authViewModel.errorMessage = "Password must be at least 6 characters long."
                    showError = true
                    print("Registration failed: password too short.")
                    return
                }
                
                // Log attempt and call register function
                print("Attempting registration with username: \(username), email: \(email)")
                authViewModel.register(username: username, email: email, password: password)
            }) {
                Text("Register")
                    .font(.custom("Montserrat-SemiBold", size: 20))
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.customDarkBlue)  // Ensure Color.customDarkBlue is defined in your project.
                    .foregroundColor(.white)
                    .cornerRadius(10)
                    .padding(.horizontal, 30)
            }
            
            // MARK: - Display Error Message, if any.
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
        .navigationBarBackButtonHidden(true)
        .toolbar {
            // Custom back button styled to mimic Apple's standard design
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: {
                    presentationMode.wrappedValue.dismiss()
                    print("Back button tapped, dismissing RegisterView.")
                }) {
                    HStack {
                        Image(systemName: "chevron.left")
                        Text("Back")
                            .font(.custom("Montserrat-Regular", size: 16))
                    }
                    .foregroundColor(.blue)
                }
            }
        }
        .navigationTitle("Register")
        // Listen for authentication changes.
        .onReceive(authViewModel.$isAuthenticated) { isAuthenticated in
            if isAuthenticated {
                print("Registration successful!")
                showSuccessAlert = true
            }
        }
        // Success alert for a positive registration outcome.
        .alert(isPresented: $showSuccessAlert) {
            Alert(
                title: Text("Success"),
                message: Text("Registration successful!"),
                dismissButton: .default(Text("OK"), action: {
                    // After dismissing, navigate to HomeView.
                    presentationMode.wrappedValue.dismiss()
                })
            )
        }
    }
}

// MARK: - Preview Provider
struct RegisterView_Previews: PreviewProvider {
    static var previews: some View {
        RegisterView()
            .environmentObject(AuthViewModel())
    }
}
