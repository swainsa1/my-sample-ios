//
//  ValidationServiceTests.swift
//  MySampleiOSAppTests
//
//  Created on 2025-11-01.
//

import XCTest
@testable import MySampleiOSApp

final class ValidationServiceTests: XCTestCase {
    var validationService: ValidationService!

    override func setUp() {
        super.setUp()
        validationService = ValidationService()
    }

    override func tearDown() {
        validationService = nil
        super.tearDown()
    }

    // MARK: - Email Validation Tests

    func testValidEmail() {
        let validEmails = [
            "test@example.com",
            "user.name@example.com",
            "user+tag@example.co.uk",
            "test123@test-domain.com"
        ]

        for email in validEmails {
            let result = validationService.validateEmail(email)
            XCTAssertNil(result, "Expected '\(email)' to be valid, but got: \(result ?? "nil")")
        }
    }

    func testInvalidEmail() {
        let invalidEmails = [
            "notanemail",
            "@example.com",
            "user@",
            "user @example.com",
            "user@.com",
            "user@domain",
            ""
        ]

        for email in invalidEmails {
            let result = validationService.validateEmail(email)
            XCTAssertNotNil(result, "Expected '\(email)' to be invalid")
        }
    }

    func testEmptyEmail() {
        let result = validationService.validateEmail("")
        XCTAssertEqual(result, "Email is required")
    }

    func testEmailWithInvalidFormat() {
        let result = validationService.validateEmail("invalid-email")
        XCTAssertEqual(result, "Please enter a valid email address")
    }

    // MARK: - Password Validation Tests

    func testValidPassword() {
        let validPasswords = [
            "Password123",
            "Test1234",
            "Secure123Pass",
            "MyP@ssw0rd"
        ]

        for password in validPasswords {
            let result = validationService.validatePassword(password)
            XCTAssertNil(result, "Expected '\(password)' to be valid, but got: \(result ?? "nil")")
        }
    }

    func testEmptyPassword() {
        let result = validationService.validatePassword("")
        XCTAssertEqual(result, "Password is required")
    }

    func testPasswordTooShort() {
        let result = validationService.validatePassword("Pass1")
        XCTAssertEqual(result, "Password must be at least 8 characters")
    }

    func testPasswordWithoutUppercase() {
        let result = validationService.validatePassword("password123")
        XCTAssertEqual(result, "Password must contain at least one uppercase letter")
    }

    func testPasswordWithoutNumber() {
        let result = validationService.validatePassword("Password")
        XCTAssertEqual(result, "Password must contain at least one number")
    }

    func testPasswordMinimumLength() {
        let result = validationService.validatePassword("Pass123")
        XCTAssertNotNil(result)
    }

    func testPasswordExactlyEightCharacters() {
        let result = validationService.validatePassword("Pass1234")
        XCTAssertNil(result)
    }

    func testPasswordWithSpecialCharacters() {
        let result = validationService.validatePassword("P@ssw0rd!")
        XCTAssertNil(result, "Password with special characters should be valid")
    }

    func testPasswordWithSpaces() {
        let result = validationService.validatePassword("Pass 123")
        XCTAssertNil(result, "Password with spaces but meeting other requirements should be valid")
    }
}
