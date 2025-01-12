import SwiftUI

struct RegisterView: View {
    @EnvironmentObject var authViewModel: AuthViewModel

    // State for form inputs and navigation
    @State private var username: String = ""
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var showError: Bool = false
    @State private var navigateToHome: Bool = false

    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                Spacer()
                Text("Create an Account")
                    .font(.custom("Montserrat-Bold", size: 28))
                    .foregroundStyle(LinearGradient.textGradient)
                    .padding(.top, 20)
                
                TextField("Username", text: $username)
                    .padding()
                    .frame(width: 300)
                    .background(Color(.secondarySystemBackground))
                    .cornerRadius(5)
                
                TextField("Email", text: $email)
                    .keyboardType(.emailAddress)
                    .padding()
                    .frame(width: 300)
                    .background(Color(.secondarySystemBackground))
                    .cornerRadius(5)
                
                SecureField("Password (min 6 characters)", text: $password)
                    .padding()
                    .frame(width: 300)
                    .background(Color(.secondarySystemBackground))
                    .cornerRadius(5)
                
                Button(action: {
                    print("Attempting registration with username: \(username), email: \(email)")
                    authViewModel.register(username: username, email: email, password: password)
                }) {
                    Text("Register")
                        .font(.custom("Montserrat-SemiBold", size: 20))
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.customDarkBlue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                        .padding(.horizontal, 30)
                }

                if let error = authViewModel.errorMessage, showError {
                    Text(error)
                        .foregroundColor(.red)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 20)
                        .transition(.opacity)
                }

                Spacer()

                NavigationLink(
                    destination: HomeView(authVM: authViewModel),
                    isActive: $navigateToHome
                ) {
                    EmptyView()
                }
            }
            .padding()
            .navigationBarBackButtonHidden(true)
            .onReceive(authViewModel.$isAuthenticated) { isAuthenticated in
                if isAuthenticated {
                    navigateToHome = true
                } else {
                    showError = authViewModel.errorMessage != nil
                }
            }
        }
    }
}

struct RegisterView_Previews: PreviewProvider {
    static var previews: some View {
        RegisterView()
            .environmentObject(AuthViewModel())
    }
}
