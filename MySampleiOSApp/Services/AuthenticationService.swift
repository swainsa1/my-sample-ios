//
//  AuthenticationService.swift
//  MySampleiOSApp
//
//  Created on 2025-11-01.
//

import Foundation

enum AuthenticationError: Error, LocalizedError {
    case invalidCredentials
    case networkError
    case serverError
    case unknown

    var errorDescription: String? {
        switch self {
        case .invalidCredentials:
            return "Invalid email or password"
        case .networkError:
            return "Network connection error"
        case .serverError:
            return "Server error, please try again later"
        case .unknown:
            return "An unknown error occurred"
        }
    }
}

protocol AuthenticationServiceProtocol {
    func login(email: String, password: String) async throws -> Bool
    func logout()
    func isAuthenticated() -> Bool
}

class AuthenticationService: AuthenticationServiceProtocol {
    private var currentUser: String?

    // Mock credentials for testing
    private let validEmail = "test@example.com"
    private let validPassword = "Password123"

    func login(email: String, password: String) async throws -> Bool {
        // Simulate network delay
        try await Task.sleep(nanoseconds: 1_000_000_000) // 1 second

        // Mock authentication logic
        if email == validEmail && password == validPassword {
            currentUser = email
            return true
        } else {
            throw AuthenticationError.invalidCredentials
        }
    }

    func logout() {
        currentUser = nil
    }

    func isAuthenticated() -> Bool {
        return currentUser != nil
    }

    func getCurrentUser() -> String? {
        return currentUser
    }
}
