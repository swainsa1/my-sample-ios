//
//  AuthenticationServiceTests.swift
//  MySampleiOSAppTests
//
//  Created on 2025-11-01.
//

import XCTest
@testable import MySampleiOSApp

final class AuthenticationServiceTests: XCTestCase {
    var authService: AuthenticationService!

    override func setUp() {
        super.setUp()
        authService = AuthenticationService()
    }

    override func tearDown() {
        authService = nil
        super.tearDown()
    }

    // MARK: - Login Tests

    func testSuccessfulLogin() async throws {
        let result = try await authService.login(
            email: "test@example.com",
            password: "Password123"
        )

        XCTAssertTrue(result)
        XCTAssertTrue(authService.isAuthenticated())
        XCTAssertEqual(authService.getCurrentUser(), "test@example.com")
    }

    func testLoginWithInvalidEmail() async {
        do {
            _ = try await authService.login(
                email: "wrong@example.com",
                password: "Password123"
            )
            XCTFail("Expected login to throw an error")
        } catch let error as AuthenticationError {
            XCTAssertEqual(error, AuthenticationError.invalidCredentials)
            XCTAssertFalse(authService.isAuthenticated())
        } catch {
            XCTFail("Expected AuthenticationError but got \(error)")
        }
    }

    func testLoginWithInvalidPassword() async {
        do {
            _ = try await authService.login(
                email: "test@example.com",
                password: "WrongPassword"
            )
            XCTFail("Expected login to throw an error")
        } catch let error as AuthenticationError {
            XCTAssertEqual(error, AuthenticationError.invalidCredentials)
            XCTAssertFalse(authService.isAuthenticated())
        } catch {
            XCTFail("Expected AuthenticationError but got \(error)")
        }
    }

    func testLoginWithEmptyCredentials() async {
        do {
            _ = try await authService.login(email: "", password: "")
            XCTFail("Expected login to throw an error")
        } catch let error as AuthenticationError {
            XCTAssertEqual(error, AuthenticationError.invalidCredentials)
            XCTAssertFalse(authService.isAuthenticated())
        } catch {
            XCTFail("Expected AuthenticationError but got \(error)")
        }
    }

    // MARK: - Logout Tests

    func testLogout() async throws {
        // First login
        _ = try await authService.login(
            email: "test@example.com",
            password: "Password123"
        )
        XCTAssertTrue(authService.isAuthenticated())

        // Then logout
        authService.logout()
        XCTAssertFalse(authService.isAuthenticated())
        XCTAssertNil(authService.getCurrentUser())
    }

    // MARK: - Authentication State Tests

    func testInitialAuthenticationState() {
        XCTAssertFalse(authService.isAuthenticated())
        XCTAssertNil(authService.getCurrentUser())
    }

    func testIsAuthenticatedAfterLogin() async throws {
        XCTAssertFalse(authService.isAuthenticated())

        _ = try await authService.login(
            email: "test@example.com",
            password: "Password123"
        )

        XCTAssertTrue(authService.isAuthenticated())
    }

    func testIsAuthenticatedAfterLogout() async throws {
        _ = try await authService.login(
            email: "test@example.com",
            password: "Password123"
        )
        XCTAssertTrue(authService.isAuthenticated())

        authService.logout()
        XCTAssertFalse(authService.isAuthenticated())
    }

    // MARK: - Current User Tests

    func testGetCurrentUserWhenNotLoggedIn() {
        XCTAssertNil(authService.getCurrentUser())
    }

    func testGetCurrentUserWhenLoggedIn() async throws {
        _ = try await authService.login(
            email: "test@example.com",
            password: "Password123"
        )

        XCTAssertEqual(authService.getCurrentUser(), "test@example.com")
    }

    func testGetCurrentUserAfterLogout() async throws {
        _ = try await authService.login(
            email: "test@example.com",
            password: "Password123"
        )
        XCTAssertNotNil(authService.getCurrentUser())

        authService.logout()
        XCTAssertNil(authService.getCurrentUser())
    }

    // MARK: - Error Description Tests

    func testAuthenticationErrorDescriptions() {
        XCTAssertEqual(
            AuthenticationError.invalidCredentials.errorDescription,
            "Invalid email or password"
        )
        XCTAssertEqual(
            AuthenticationError.networkError.errorDescription,
            "Network connection error"
        )
        XCTAssertEqual(
            AuthenticationError.serverError.errorDescription,
            "Server error, please try again later"
        )
        XCTAssertEqual(
            AuthenticationError.unknown.errorDescription,
            "An unknown error occurred"
        )
    }
}
