//
//  LoginViewModel.swift
//  MySampleiOSApp
//
//  Created on 2025-11-01.
//

import Foundation
import Combine

@MainActor
class LoginViewModel: ObservableObject {
    // Published properties for UI binding
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    @Published var isLoggedIn: Bool = false

    // Validation states
    @Published var emailError: String?
    @Published var passwordError: String?

    private let authService: AuthenticationService
    private let validationService: ValidationService
    private var cancellables = Set<AnyCancellable>()

    var isFormValid: Bool {
        !email.isEmpty &&
        !password.isEmpty &&
        emailError == nil &&
        passwordError == nil
    }

    init(authService: AuthenticationService = AuthenticationService(),
         validationService: ValidationService = ValidationService()) {
        self.authService = authService
        self.validationService = validationService

        setupValidation()
    }

    private func setupValidation() {
        // Email validation
        $email
            .debounce(for: .milliseconds(500), scheduler: RunLoop.main)
            .removeDuplicates()
            .map { [weak self] email in
                guard let self = self else { return nil }
                if email.isEmpty {
                    return nil
                }
                return self.validationService.validateEmail(email)
            }
            .assign(to: &$emailError)

        // Password validation
        $password
            .debounce(for: .milliseconds(500), scheduler: RunLoop.main)
            .removeDuplicates()
            .map { [weak self] password in
                guard let self = self else { return nil }
                if password.isEmpty {
                    return nil
                }
                return self.validationService.validatePassword(password)
            }
            .assign(to: &$passwordError)
    }

    func login() async {
        guard isFormValid else {
            errorMessage = "Please fix all validation errors"
            return
        }

        isLoading = true
        errorMessage = nil

        do {
            let success = try await authService.login(email: email, password: password)

            if success {
                isLoggedIn = true
                errorMessage = nil
            } else {
                errorMessage = "Invalid credentials"
            }
        } catch {
            errorMessage = error.localizedDescription
        }

        isLoading = false
    }

    func logout() {
        authService.logout()
        isLoggedIn = false
        email = ""
        password = ""
        errorMessage = nil
    }

    func clearErrors() {
        errorMessage = nil
        emailError = nil
        passwordError = nil
    }
}
