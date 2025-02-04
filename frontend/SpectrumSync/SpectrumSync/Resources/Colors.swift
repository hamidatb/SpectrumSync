//
// Resources/Colors.swift
//  SpectrumSync
//
//  Created by Hamidat Bello on 2025-01-11.

import SwiftUI

extension Color {
    // Yellow Shades
    static let customLightYellow = Color(hex: "#FFF7D3")
    static let customYellow = Color(hex: "#FFBF32")
    static let customDarkBrown = Color(hex: "#462104")

    // Green Shades
    static let customLightGreen = Color(hex: "#E5F9CE")
    static let customGreen = Color(hex: "#529917")
    static let customDarkGreen = Color(hex: "#162B08")

    // Grayscale Shades
    static let customLightGray = Color(hex: "#F6F6F6")
    static let customGray = Color(hex: "#5D5D5D")
    static let customBlack = Color(hex: "#0F0F0F")

    // Blue Shades
    static let customLightBlue = Color(hex: "#BAF4FF")
    static let customBlue = Color(hex: "#1EC6F2")
    static let customDarkBlue = Color(hex: "#072F45")
    
    // Navbar Shades
    static let currNavButtonBgColour = Color(hex: "#80CADE")
    static let navButtonFgColour = Color(hex: "#A9CED8")
    static let currNavButtonFgColour = Color(hex: "#FFFFFF")
    
    // Background
    static let paleBlueBg = Color(hex: "#E7FBFF")
}

// Utility to convert hex color codes to SwiftUI Color
extension Color {
    init(hex: String) {
        var hexString = hex
        if hexString.hasPrefix("#") {
            hexString.removeFirst()
        }
        
        let scanner = Scanner(string: hexString)
        var rgbValue: UInt64 = 0
        scanner.scanHexInt64(&rgbValue)

        let red = Double((rgbValue >> 16) & 0xFF) / 255.0
        let green = Double((rgbValue >> 8) & 0xFF) / 255.0
        let blue = Double(rgbValue & 0xFF) / 255.0

        self.init(red: red, green: green, blue: blue)
    }
}

extension LinearGradient {
    static let buttonGradient = LinearGradient(
        gradient: Gradient(colors: [Color.customLightBlue, Color.customBlue]),
        startPoint: .leading,
        endPoint: .trailing
    )
        
    // Gradient for background
    static let backgroundGradient = LinearGradient(
        gradient: Gradient(colors: [Color(hex: "#BAF4FF"), Color(hex: "#FFF7D3")]),
        startPoint: .top,
        endPoint: .bottom
    )
    
    // Gradient to apply on text elements
    static let textGradient = LinearGradient(
        gradient: Gradient(colors: [Color.customBlue, Color.customLightBlue]),
        startPoint: .leading,
        endPoint: .trailing
    )
    
    static let darkBlueTextGradient = LinearGradient(
        gradient: Gradient(colors: [.blue, Color.customBlue]),
        startPoint: .leading,
        endPoint: .trailing
    )
}
