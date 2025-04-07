import SwiftUI

struct CalNavigationBar: View {
    let logoName: String
    let onBack: () -> Void // have to pass the back button arg here

    var body: some View {
        ZStack {
            HStack {
                createBackButton()
                Spacer()
            }
            createLogo()
        }
        .padding(.top, 8)
        .padding(.leading, 20)
        .frame(maxWidth: .infinity)
        //.background(.red)
    }
}

private extension CalNavigationBar {
    func createBackButton() -> some View {
        Button(action: onBack) {
            Image(systemName: "chevron.left")
                .foregroundColor(.customBlue)
                .font(.system(size: 30, weight: .bold))
                .padding(8)
        }
    }

    func createLogo() -> some View {
        Image(logoName)
            .resizable()
            .scaledToFit()
            .frame(height: 80)
    }
}

// MARK: - Preview
#Preview {
    CalNavigationBar(logoName: "LogoDark") {
            print("Back button tapped")
    }
    .padding(.horizontal, 24)
}
