//
//  AuthenticationTests.swift
//  NinjaWarriorsTests
//
//  Created by Muhammad Reyaaz on 23/3/24.
//

import XCTest
import FirebaseAuth
import FirebaseDatabase
@testable import NinjaWarriors

final class AuthenticationTests: XCTestCase {
    var authenticationAdapter: Authentication?

    override func setUp() {
        super.setUp()
        authenticationAdapter = AuthenticationAdapter()
    }

    override func tearDown() {
        authenticationAdapter = nil
        super.tearDown()
    }

    func testSignUpWithValidCredentials() async throws {
        let expectation = XCTestExpectation(description: "Sign up with valid credentials")
        guard let authenticationAdapter = authenticationAdapter else {
            XCTFail("Authentication adapter is nil")
            return
        }
        do {
            let user = try await authenticationAdapter.signUp(email: "test@example.com", password: "Password123")
            XCTAssertNotNil(user)
        } catch {
            XCTFail("Error occurred while signing up: \(error)")
        }
        expectation.fulfill()
        wait(for: [expectation], timeout: 5.0)
        try await authenticationAdapter.delete()
    }

    func testGetAuthenticatedUserWhenLoggedIn() async throws {
        let expectation = XCTestExpectation(description: "Get authenticated user when logged in")

        guard let authenticationAdapter = authenticationAdapter else {
            XCTFail("Authentication adapter is nil")
            return
        }
        do {
            let user = try await authenticationAdapter.signUp(email: "test@example.com", password: "Password123")
            XCTAssertNotNil(user)
        } catch {
            XCTFail("Error occurred while signing up: \(error)")
        }

        do {
            let user = try authenticationAdapter.getAuthenticatedUser()
            XCTAssertNotNil(user)
        } catch {
            XCTFail("Error occurred while getting authenticated user: \(error)")
        }
        expectation.fulfill()
        wait(for: [expectation], timeout: 5.0)
        try await authenticationAdapter.delete()
    }

    func testResetPasswordWithValidEmail() async throws {
        let expectation = XCTestExpectation(description: "Reset password with valid email")
        guard let authenticationAdapter = authenticationAdapter else {
            XCTFail("Authentication adapter is nil")
            return
        }
        do {
            let user = try await authenticationAdapter.signUp(email: "test@example.com", password: "Password123")
            XCTAssertNotNil(user)
        } catch {
            XCTFail("Error occurred while signing up: \(error)")
        }

        do {
            try await authenticationAdapter.resetPassword(email: "test@example.com")
        } catch {
            XCTFail("Error occurred while resetting password: \(error)")
        }
        expectation.fulfill()
        wait(for: [expectation], timeout: 5.0)
        try await authenticationAdapter.delete()
    }

    func testSignUpWithEmptyEmail() async {
        let expectation = XCTestExpectation(description: "Sign up with empty email")
        guard let authenticationAdapter = authenticationAdapter else {
            XCTFail("Authentication adapter is nil")
            return
        }
        do {
            _ = try await authenticationAdapter.signUp(email: "", password: "Password123")
            XCTFail("Expected sign up with empty email to throw an error")
        } catch {
            XCTAssertNotNil(error)
        }
        expectation.fulfill()

        wait(for: [expectation], timeout: 5.0)
    }

    func testSignUpWithEmptyPassword() async throws {
        let expectation = XCTestExpectation(description: "Sign up with empty password")
        guard let authenticationAdapter = authenticationAdapter else {
            XCTFail("Authentication adapter is nil")
            return
        }
        do {
            let user = try await authenticationAdapter.signUp(email: "test@example.com", password: "Password123")
            XCTAssertNotNil(user)
        } catch {
            XCTFail("Error occurred while signing up: \(error)")
        }
        try await authenticationAdapter.delete()
        
        do {
            _ = try await authenticationAdapter.signUp(email: "test@example.com", password: "")
            XCTFail("Expected sign up with empty password to throw an error")
        } catch {
            XCTAssertNotNil(error)
        }
        expectation.fulfill()
        wait(for: [expectation], timeout: 5.0)
    }

    func testSignUpWithInvalidEmailFormat() async {
        let expectation = XCTestExpectation(description: "Sign up with invalid email format")
        guard let authenticationAdapter = authenticationAdapter else {
            XCTFail("Authentication adapter is nil")
            return
        }
        do {
            _ = try await authenticationAdapter.signUp(email: "invalid_email", password: "Password123")
            XCTFail("Expected sign up with invalid email format to throw an error")
        } catch {
            XCTAssertNotNil(error)
        }
        expectation.fulfill()
        wait(for: [expectation], timeout: 5.0)
    }

    func testSignUpWithWeakPassword() async {
        let expectation = XCTestExpectation(description: "Sign up with weak password")
        guard let authenticationAdapter = authenticationAdapter else {
            XCTFail("Authentication adapter is nil")
            return
        }
        do {
            _ = try await authenticationAdapter.signUp(email: "testing@example.com", password: "weak")
            XCTFail("Expected sign up with weak password to throw an error")
        } catch {
            XCTAssertNotNil(error)
        }
        expectation.fulfill()
        wait(for: [expectation], timeout: 5.0)
    }

    func testSignUpWithExistingEmail() async throws {
        let expectation = XCTestExpectation(description: "Sign up with existing email")
        guard let authenticationAdapter = authenticationAdapter else {
            XCTFail("Authentication adapter is nil")
            return
        }
        do {
            // First, sign up with the existing email
            _ = try await authenticationAdapter.signUp(email: "exist@example.com", password: "Password123")
            // Then try signing up again with the same email
            do {
                _ = try await authenticationAdapter.signUp(email: "exist@example.com", password: "AnotherPassword")
                XCTFail("Expected sign up with existing email to throw an error")
                try await authenticationAdapter.delete()
            } catch {
                XCTAssertNotNil(error)
            }
        } catch {
            XCTFail("Error occurred while signing up: \(error)")
        }
        expectation.fulfill()
        wait(for: [expectation], timeout: 10.0)
        try await authenticationAdapter.delete()
    }

    func testSignInWithEmptyEmail() async throws {
        let expectation = XCTestExpectation(description: "Sign in with empty email")
        guard let authenticationAdapter = authenticationAdapter else {
            XCTFail("Authentication adapter is nil")
            return
        }
        do {
            _ = try await authenticationAdapter.signIn(email: "", password: "Password123")
            XCTFail("Expected sign in with empty email to throw an error")
        } catch {
            XCTAssertNotNil(error)
        }
        expectation.fulfill()
        wait(for: [expectation], timeout: 5.0)
    }

    func testSignInWithEmptyPassword() async {
        let expectation = XCTestExpectation(description: "Sign in with empty password")
        guard let authenticationAdapter = authenticationAdapter else {
            XCTFail("Authentication adapter is nil")
            return
        }
        do {
            _ = try await authenticationAdapter.signIn(email: "test@example.com", password: "")
            XCTFail("Expected sign in with empty password to throw an error")
        } catch {
            XCTAssertNotNil(error)
        }
        expectation.fulfill()
        wait(for: [expectation], timeout: 5.0)
    }

    func testSignInWithInvalidEmailFormat() async {
        let expectation = XCTestExpectation(description: "Sign in with invalid email format")
        guard let authenticationAdapter = authenticationAdapter else {
            XCTFail("Authentication adapter is nil")
            return
        }
        do {
            _ = try await authenticationAdapter.signIn(email: "invalid_email", password: "Password123")
            XCTFail("Expected sign in with invalid email format to throw an error")
        } catch {
            XCTAssertNotNil(error)
        }
        expectation.fulfill()
        wait(for: [expectation], timeout: 5.0)
    }

    func testSignInWithIncorrectCredentials() async {
        let expectation = XCTestExpectation(description: "Sign in with incorrect credentials")
        guard let authenticationAdapter = authenticationAdapter else {
            XCTFail("Authentication adapter is nil")
            return
        }
        do {
            _ = try await authenticationAdapter.signIn(email: "nonexistent@example.com", password: "WrongPassword")
            XCTFail("Expected sign in with incorrect credentials to throw an error")
        } catch {
            XCTAssertNotNil(error)
        }
        expectation.fulfill()
        wait(for: [expectation], timeout: 5.0)
    }

    func testResetPasswordWithEmptyEmail() async {
        let expectation = XCTestExpectation(description: "Reset password with empty email")
        guard let authenticationAdapter = authenticationAdapter else {
            XCTFail("Authentication adapter is nil")
            return
        }
        do {
            try await authenticationAdapter.resetPassword(email: "")
            XCTFail("Expected reset password with empty email to throw an error")
        } catch {
            XCTAssertNotNil(error)
        }
        expectation.fulfill()
        wait(for: [expectation], timeout: 5.0)
    }

    func testResetPasswordWithInvalidEmailFormat() async {
        let expectation = XCTestExpectation(description: "Reset password with invalid email format")
        guard let authenticationAdapter = authenticationAdapter else {
            XCTFail("Authentication adapter is nil")
            return
        }
        do {
            try await authenticationAdapter.resetPassword(email: "invalid_email")
            XCTFail("Expected reset password with invalid email format to throw an error")
        } catch {
            XCTAssertNotNil(error)
        }
        expectation.fulfill()
        wait(for: [expectation], timeout: 5.0)
    }
}
