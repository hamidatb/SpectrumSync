import SwiftUI

struct AuthView: View {
    @StateObject var authVM = AuthViewModel()
    @State private var isLogin = true
    @State private var username = ""
    @State private var email = ""
    @State private var password = ""
    @State private var navigateToHome = false
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                if !isLogin {
                    TextField("Username", text: $username)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding(.horizontal)
                }
                TextField("Email", text: $email)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.horizontal)
                    .keyboardType(.emailAddress)
                SecureField("Password", text: $password)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.horizontal)

                if isLogin {
                    Button("Login") {
                        authVM.login(email: email, password: password)
                        navigateToHome = authVM.isAuthenticated
                    }
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(8)
                } else {
                    Button("Register") {
                        authVM.register(username: username, email: email, password: password)
                        navigateToHome = authVM.isAuthenticated
                    }
                    .padding()
                    .background(Color.green)
                    .foregroundColor(.white)
                    .cornerRadius(8)
                }

                if let errorMessage = authVM.errorMessage {
                    Text(errorMessage)
                        .foregroundColor(.red)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                }

                Button(isLogin ? "Don't have an account? Register" : "Already have an account? Login") {
                    isLogin.toggle()
                }
                .font(.footnote)

                // NavigationLink using new approach
                NavigationLink(
                    destination: HomeView(authVM: authVM),
                    isActive: $navigateToHome
                ) {
                    EmptyView()
                }
            }
            .navigationTitle(isLogin ? "Login" : "Register")
        }
    }
}

struct AuthView_Previews: PreviewProvider {
    static var previews: some View {
        AuthView()
    }
}
