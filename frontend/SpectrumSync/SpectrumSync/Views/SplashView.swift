// SpectrumSync/Views/SplashView.swift

import SwiftUI

struct SplashView: View {
    @State private var isActive = false

    var body: some View {
        if isActive {
            ChooseLoginRegisterView()
        } else {
            VStack {
                Image(systemName: "calendar")
                    .resizable()
                    .frame(width: 100, height: 100)
                    .padding()
                Text("Welcome to SpectrumSync")
                    .font(.largeTitle)
                    .fontWeight(.bold)
            }
            .onAppear {
                // Simulate a loading delay
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    withAnimation {
                        self.isActive = true
                    }
                }
            }
        }
    }
}

struct SplashView_Previews: PreviewProvider {
    static var previews: some View {
        SplashView()
    }
}
