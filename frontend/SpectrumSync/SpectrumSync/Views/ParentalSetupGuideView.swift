//
//  ParentalSetupGuideView.swift
//  SpectrumSync
//
//  Created by Hamidat Bello on 2025-04-06.
//
import SwiftUI

struct ParentalSetupGuideView: View {
    @Environment(\.dismiss) var dismiss

    var body: some View {
        CalNavigationBar(logoName: "LogoDark", onBack: ({
            dismiss()
        }))

        ScrollView {
            VStack(alignment: .leading, spacing: 32) {

                // MARK: - Header
                Text("Parental Setup Guide")
                    .font(.system(size: 28, weight: .bold, design: .rounded))
                    .foregroundColor(.customDarkBlue)
                    .padding(.top, 10)

                Text("Welcome! SpectrumSync is a supportive app designed to help children manage their daily routines and events independently.")
                    .font(.body)
                    .foregroundColor(.secondary)


                // MARK: - Account Management
                GuideCard(
                    icon: "key.fill",
                    title: "Manage Accounts & Passwords",
                    content: "To create or manage your child’s account and password, please visit our website. All account-level actions like password resets, usernames, and parental controls are available there."
                )

                // MARK: - Event Management
                GuideCard(
                    icon: "calendar.badge.plus",
                    title: "Add or Edit Events Remotely",
                    content: "Use the website to create or modify your child’s schedule. All changes will sync automatically to their device."
                )

                // MARK: - Website Access
                VStack(alignment: .leading, spacing: 12) {
                    HStack {
                        Image(systemName: "globe")
                            .foregroundColor(.customBlue)
                        Text("Visit the Website")
                            .font(.headline)
                            .foregroundColor(.customDarkBlue)
                    }

                    Text("All parental actions — account setup, event management, and profile settings — should be done through:")
                        .font(.body)
                        .foregroundColor(.secondary)

                    Text("www.spectrumsync.app")
                        .font(.body.bold())
                        .foregroundColor(.customBlue)
                        .underline()
                        .padding(.top, 4)
                }
                .padding()
                .background(Color.white)
                .cornerRadius(16)
                .shadow(color: Color.customBlue.opacity(0.1), radius: 6)
                
                // MARK: - About the App
                VStack(alignment: .leading, spacing: 12) {
                    HStack {
                        Image(systemName: "heart.fill")
                            .foregroundColor(.customBlue)
                        Text("Why I Made This App")
                            .font(.headline)
                            .foregroundColor(.customDarkBlue)
                    }

                    Text("I originally built SpectrumSync for my little brother who is autistic. I wanted him to have a simple and gentle way to keep track of his day.")
                        .font(.body)
                        .foregroundColor(.secondary)

                    Text("Now, I hope that every family and child who could benefit from it feels welcome to use it too. 💙")
                        .font(.body)
                        .foregroundColor(.secondary)
                }
                .padding()
                .background(Color.white)
                .cornerRadius(16)
                .shadow(color: Color.customBlue.opacity(0.08), radius: 5)
                
                

                // MARK: - Canadian Autism Resources
                VStack(alignment: .leading, spacing: 12) {
                    HStack {
                        Image(systemName: "lightbulb.fill")
                            .foregroundColor(.customBlue)
                        Text("Autism Support in Canada")
                            .font(.headline)
                            .foregroundColor(.customDarkBlue)
                    }
                    
        

                    Text("Here are trusted Canadian organizations that provide support and guidance for families:")
                        .font(.body)
                        .foregroundColor(.secondary)

                    VStack(alignment: .leading, spacing: 10) {
                        ResourceLink(title: "Autism Canada", url: "https://autismcanada.org")
                        ResourceLink(title: "Ontario Autism Program", url: "https://www.ontario.ca/page/ontario-autism-program")
                        ResourceLink(title: "Pacific Autism Family Network", url: "https://www.pacificautismfamily.com")
                        ResourceLink(title: "The Sinneave Family Foundation", url: "https://sinneavefoundation.org")
                        ResourceLink(title: "Autism Society of Alberta", url: "https://autismalberta.ca")
                    }
                }
                .padding()
                .background(Color.white)
                .cornerRadius(16)
                .shadow(color: Color.customBlue.opacity(0.1), radius: 6)

                Spacer(minLength: 40)
                
            }
            .padding(.horizontal, 24) // 🆕 More side padding for clean layout
            .padding(.top)
        }
        .navigationBarHidden(true)
    }
}

// MARK: - Reusable Guide Card
struct GuideCard: View {
    let icon: String
    let title: String
    let content: String

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: icon)
                    .foregroundColor(.customBlue)
                Text(title)
                    .font(.headline)
                    .foregroundColor(.customDarkBlue)
            }

            Text(content)
                .font(.body)
                .foregroundColor(.secondary)
        }
        .padding()
        .background(Color.customLightBlue.opacity(0.5))
        .cornerRadius(16)
        .shadow(color: Color.customLightBlue.opacity(1), radius: 6)
    }
}

// MARK: - Resource Link View
struct ResourceLink: View {
    let title: String
    let url: String

    var body: some View {
        Link(destination: URL(string: url)!) {
            Text("🔗 \(title)")
                .font(.body)
                .foregroundColor(.customBlue)
                .underline()
        }
    }
}


#Preview {
    ParentalSetupGuideView()
}
