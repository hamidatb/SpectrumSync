//
// Environment/EnvironmentManager.swift
//  SpectrumSync
//
//  Created by Hamidat Bello on 2025-01-26.
//

import Foundation

enum AppEnvironment {
    case production
    case development
}

// Using a singleton Environment Manager
class EnvironmentManager {
    static let shared = EnvironmentManager()
    private init() {}
    
    var currentEnvironment: AppEnvironment = .development // Change to .production as needed
}
