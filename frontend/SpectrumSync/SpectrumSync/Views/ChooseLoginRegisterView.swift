// SpectrumSync/Views/ChooseLoginRegisterView.swift

import SwiftUI

struct ChooseLoginRegisterView: View {
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                NavigationLink(destination: RegisterView()) {
                    Text("Register")
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }

                NavigationLink(destination: LoginView()) {
                    Text("Login")
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.green)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
            }
            .padding()
            .navigationTitle("Choose an Option")
        }
    }
}

struct ChooseLoginRegisterView_Previews: PreviewProvider {
    static var previews: some View {
        ChooseLoginRegisterView()
    }
}
