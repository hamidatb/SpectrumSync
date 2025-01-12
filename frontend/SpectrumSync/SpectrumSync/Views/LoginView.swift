import SwiftUI

struct LoginView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var showError: Bool = false
    @State private var showSuccessAlert: Bool = false
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        VStack(spacing: 20) {
            // MARK: - Form Header with Gradient Styling (matching RegisterView)
            Text("Login")
                .font(.custom("Montserrat-Bold", size: 28))
                .foregroundStyle(
                    LinearGradient(
                        gradient: Gradient(colors: [.blue, .purple]),
                        startPoint: .leading,
                        endPoint: .trailing)
                )
                .padding(.top, 20)
            
            // MARK: - Email Input Field
            TextField("Email", text: $email)
                .keyboardType(.emailAddress)
                .padding()
                .frame(width: 300)
                .background(Color(.secondarySystemBackground))
                .cornerRadius(5)
            
            // MARK: - Password Input Field
            SecureField("Password", text: $password)
                .padding()
                .frame(width: 300)
                .background(Color(.secondarySystemBackground))
                .cornerRadius(5)
            
            // MARK: - Login Button (same styling as RegisterView)
            Button(action: {
                print("Attempting login with email: \(email)")
                // Optionally, add local validation if needed
                authViewModel.login(email: email, password: password)
            }) {
                Text("Login")
                    .font(.custom("Montserrat-SemiBold", size: 20))
                    .frame(maxWidth: .infinity)
                    .padding()
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
                    .transition(.opacity)
            }
            
            Spacer()
        }
        .padding()
        .navigationBarBackButtonHidden(true)
        .toolbar {
            // Custom back button to match RegisterView styling.
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: {
                    presentationMode.wrappedValue.dismiss()
                    print("Back button tapped, dismissing LoginView.")
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
        .navigationTitle("Login")
        // Listen for authentication changes.
        .onReceive(authViewModel.$isAuthenticated) { isAuthenticated in
            if isAuthenticated {
                print("Login successful!")
                showSuccessAlert = true
            }
            // Reset error display if authentication state changes.
            showError = !isAuthenticated && authViewModel.errorMessage != nil
        }
        // Success alert for a positive login outcome.
        .alert(isPresented: $showSuccessAlert) {
            Alert(
                title: Text("Success"),
                message: Text("Login successful!"),
                dismissButton: .default(Text("OK"), action: {
                    // After dismissing, navigate to HomeView.
                    presentationMode.wrappedValue.dismiss()
                })
            )
        }
        // Optionally, listen to error message changes to trigger UI updates.
        .onChange(of: authViewModel.errorMessage) { newValue in
            if newValue != nil {
                showError = true
            }
        }
    }
}

// MARK: - Preview Provider
struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
            .environmentObject(AuthViewModel())
    }
}
