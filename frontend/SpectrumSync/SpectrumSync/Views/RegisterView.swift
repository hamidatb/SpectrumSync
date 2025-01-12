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
                .padding(.top, 40)
                .opacity(0.8)

            // Form Header
            Text("Create an Account")
                .font(.custom("Montserrat-Bold", size: 28))
                .foregroundStyle(
                    LinearGradient(
                        gradient: Gradient(colors: [.blue, .purple]),
                        startPoint: .leading,
                        endPoint: .trailing)
                )
                .padding(.top, 20)
            
            // Username Input Field
            TextField("Username", text: $username)
                .padding()
                .frame(maxWidth: UIScreen.main.bounds.width * 0.8) // 80% width
                .background(Color(.secondarySystemBackground))
                .cornerRadius(5)
                .autocapitalization(.none) // Prevent automatic capitalization
            
            // Email Input Field
            TextField("Email", text: $email)
                .keyboardType(.emailAddress)
                .padding()
                .frame(maxWidth: UIScreen.main.bounds.width * 0.8) // 80% width
                .background(Color(.secondarySystemBackground))
                .cornerRadius(5)
                .autocapitalization(.none) // Prevent automatic capitalization
            
            // Password Input Field
            SecureField("Password (min 6 characters)", text: $password)
                .padding()
                .frame(maxWidth: UIScreen.main.bounds.width * 0.8) // 80% width
                .background(Color(.secondarySystemBackground))
                .cornerRadius(5)
            
            // Register Button
            Button(action: {
                // Perform local validations
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
                
                if !email.contains("@") || !email.contains(".") {
                    authViewModel.errorMessage = "Please enter a valid email address."
                    showError = true
                    print("Registration failed: invalid email format.")
                    return
                }
                
                if password.count < 6 {
                    authViewModel.errorMessage = "Password must be at least 6 characters long."
                    showError = true
                    print("Registration failed: password too short.")
                    return
                }
                
                // Log registration attempt
                print("Attempting registration with username: \(username), email: \(email.lowercased())")
                
                // Call register function with lowercase email
                authViewModel.register(username: username, email: email.lowercased(), password: password)
            }) {
                Text("Register")
                    .font(.custom("Montserrat-SemiBold", size: 20))
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.customDarkBlue) // Ensure this color is defined
                    .foregroundColor(.white)
                    .cornerRadius(10)
                    .padding(.horizontal, 30)
            }

            // Display Error Message, if any
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
        .onReceive(authViewModel.$isAuthenticated) { isAuthenticated in
            if isAuthenticated {
                print("Registration successful!")
            }
            showError = authViewModel.errorMessage != nil
        }
    }

    struct RegisterView_Previews: PreviewProvider {
        static var previews: some View {
            RegisterView()
                .environmentObject(AuthViewModel())
        }
    }
}
