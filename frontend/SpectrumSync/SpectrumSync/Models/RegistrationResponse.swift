// Models/RegistrationResponse.swift
import Foundation

struct RegistrationResponse: Decodable {
    let message: String
    let token: String
    let user: User
}
