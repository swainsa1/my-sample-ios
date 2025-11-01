//
//  LoginViewModelTests.swift
//  MySampleiOSAppTests
//
//  Created on 2025-11-01.
//

import XCTest
@testable import MySampleiOSApp

// Mock Authentication Service for testing
class MockAuthenticationService: AuthenticationServiceProtocol {
    var shouldSucceed = true
    var loginCallCount = 0
    var logoutCallCount = 0
    var isAuthenticatedValue = false

    func login(email: String, password: String) async throws -> Bool {
        loginCallCount += 1
        if shouldSucceed {
            isAuthenticatedValue = true
            return true
        } else {
            throw AuthenticationError.invalidCredentials
        }
    }

    func logout() {
        logoutCallCount += 1
        isAuthenticatedValue = false
    }

    func isAuthenticated() -> Bool {
        return isAuthenticatedValue
    }
}

// Mock Validation Service for testing
class MockValidationService: ValidationServiceProtocol {
    var emailValidationResult: String?
    var passwordValidationResult: String?

    func validateEmail(_ email: String) -> String? {
        return emailValidationResult
    }

    func validatePassword(_ password: String) -> String? {
        return passwordValidationResult
    }
}

@MainActor
final class LoginViewModelTests: XCTestCase {
    var viewModel: LoginViewModel!
    var mockAuthService: MockAuthenticationService!
    var mockValidationService: MockValidationService!

    override func setUp() {
        super.setUp()
        mockAuthService = MockAuthenticationService()
        mockValidationService = MockValidationService()
        viewModel = LoginViewModel(
            authService: mockAuthService,
            validationService: mockValidationService
        )
    }

    override func tearDown() {
        viewModel = nil
        mockAuthService = nil
        mockValidationService = nil
        super.tearDown()
    }

    // MARK: - Initialization Tests

    func testInitialState() {
        XCTAssertEqual(viewModel.email, "")
        XCTAssertEqual(viewModel.password, "")
        XCTAssertFalse(viewModel.isLoading)
        XCTAssertNil(viewModel.errorMessage)
        XCTAssertFalse(viewModel.isLoggedIn)
        XCTAssertNil(viewModel.emailError)
        XCTAssertNil(viewModel.passwordError)
    }

    // MARK: - Form Validation Tests

    func testIsFormValidWithEmptyFields() {
        XCTAssertFalse(viewModel.isFormValid)
    }

    func testIsFormValidWithValidInput() {
        viewModel.email = "test@example.com"
        viewModel.password = "Password123"
        mockValidationService.emailValidationResult = nil
        mockValidationService.passwordValidationResult = nil

        XCTAssertTrue(viewModel.isFormValid)
    }

    func testIsFormValidWithInvalidEmail() {
        viewModel.email = "invalid"
        viewModel.password = "Password123"
        mockValidationService.emailValidationResult = "Invalid email"
        mockValidationService.passwordValidationResult = nil
        viewModel.emailError = "Invalid email"

        XCTAssertFalse(viewModel.isFormValid)
    }

    func testIsFormValidWithInvalidPassword() {
        viewModel.email = "test@example.com"
        viewModel.password = "weak"
        mockValidationService.emailValidationResult = nil
        mockValidationService.passwordValidationResult = "Password too weak"
        viewModel.passwordError = "Password too weak"

        XCTAssertFalse(viewModel.isFormValid)
    }

    // MARK: - Login Tests

    func testSuccessfulLogin() async {
        viewModel.email = "test@example.com"
        viewModel.password = "Password123"
        mockAuthService.shouldSucceed = true

        await viewModel.login()

        XCTAssertEqual(mockAuthService.loginCallCount, 1)
        XCTAssertTrue(viewModel.isLoggedIn)
        XCTAssertNil(viewModel.errorMessage)
        XCTAssertFalse(viewModel.isLoading)
    }

    func testFailedLogin() async {
        viewModel.email = "test@example.com"
        viewModel.password = "WrongPassword"
        mockAuthService.shouldSucceed = false

        await viewModel.login()

        XCTAssertEqual(mockAuthService.loginCallCount, 1)
        XCTAssertFalse(viewModel.isLoggedIn)
        XCTAssertNotNil(viewModel.errorMessage)
        XCTAssertFalse(viewModel.isLoading)
    }

    func testLoginWithInvalidForm() async {
        viewModel.email = ""
        viewModel.password = ""

        await viewModel.login()

        XCTAssertEqual(mockAuthService.loginCallCount, 0)
        XCTAssertFalse(viewModel.isLoggedIn)
        XCTAssertEqual(viewModel.errorMessage, "Please fix all validation errors")
    }

    func testLoadingStatesDuringLogin() async {
        viewModel.email = "test@example.com"
        viewModel.password = "Password123"
        mockAuthService.shouldSucceed = true

        let expectation = XCTestExpectation(description: "Login completes")

        Task {
            await viewModel.login()
            XCTAssertFalse(viewModel.isLoading)
            expectation.fulfill()
        }

        // Brief delay to check loading state
        try? await Task.sleep(nanoseconds: 100_000_000)

        await fulfillment(of: [expectation], timeout: 5.0)
    }

    // MARK: - Logout Tests

    func testLogout() {
        viewModel.email = "test@example.com"
        viewModel.password = "Password123"
        viewModel.isLoggedIn = true
        viewModel.errorMessage = "Some error"

        viewModel.logout()

        XCTAssertEqual(mockAuthService.logoutCallCount, 1)
        XCTAssertFalse(viewModel.isLoggedIn)
        XCTAssertEqual(viewModel.email, "")
        XCTAssertEqual(viewModel.password, "")
        XCTAssertNil(viewModel.errorMessage)
    }

    // MARK: - Clear Errors Tests

    func testClearErrors() {
        viewModel.errorMessage = "Some error"
        viewModel.emailError = "Email error"
        viewModel.passwordError = "Password error"

        viewModel.clearErrors()

        XCTAssertNil(viewModel.errorMessage)
        XCTAssertNil(viewModel.emailError)
        XCTAssertNil(viewModel.passwordError)
    }
}
