//
//  ValidationService.swift
//  MySampleiOSApp
//
//  Created on 2025-11-01.
//

import Foundation

protocol ValidationServiceProtocol {
    func validateEmail(_ email: String) -> String?
    func validatePassword(_ password: String) -> String?
}

class ValidationService: ValidationServiceProtocol {

    func validateEmail(_ email: String) -> String? {
        // Check if email is empty
        guard !email.isEmpty else {
            return "Email is required"
        }

        // Email regex pattern
        let emailRegex = "^[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}$"
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)

        if !emailPredicate.evaluate(with: email) {
            return "Please enter a valid email address"
        }

        return nil
    }

    func validatePassword(_ password: String) -> String? {
        // Check if password is empty
        guard !password.isEmpty else {
            return "Password is required"
        }

        // Check minimum length
        guard password.count >= 8 else {
            return "Password must be at least 8 characters"
        }

        // Check for at least one uppercase letter
        let uppercaseRegex = ".*[A-Z]+.*"
        let uppercasePredicate = NSPredicate(format: "SELF MATCHES %@", uppercaseRegex)
        guard uppercasePredicate.evaluate(with: password) else {
            return "Password must contain at least one uppercase letter"
        }

        // Check for at least one number
        let numberRegex = ".*[0-9]+.*"
        let numberPredicate = NSPredicate(format: "SELF MATCHES %@", numberRegex)
        guard numberPredicate.evaluate(with: password) else {
            return "Password must contain at least one number"
        }

        return nil
    }
}
