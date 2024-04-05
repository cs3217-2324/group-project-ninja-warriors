//
//  AuthenticationAdapter.swift
//  NinjaWarriors
//
//  Created by Muhammad Reyaaz on 13/3/24.
//

import Foundation
import FirebaseAuth

final class AuthenticationAdapter: Authentication {

    private let authenticator: Auth? = nil

    @discardableResult
    func signUp(email: String, password: String) async throws -> User {
        let authDataResult = try await Auth.auth().createUser(withEmail: email, password: password)
        let user = authDataResult.user
        return User(uid: user.uid, email: user.email)
    }

    @discardableResult
    func signIn(email: String, password: String) async throws -> User {
        let authDataResult = try await Auth.auth().signIn(withEmail: email, password: password)
        let user = authDataResult.user
        return User(uid: user.uid, email: user.email)
    }

    func getAuthenticatedUser() throws -> User {
        guard let user = Auth.auth().currentUser else {
            throw URLError(.badServerResponse)
        }
        return User(uid: user.uid, email: user.email)
    }

    func resetPassword(email: String) async {
        do {
            try await Auth.auth().sendPasswordReset(withEmail: email)
        } catch {
            print("Error with reset password: \(error)")
        }
    }

    func updatePassword(password: String) async {
        guard let user = Auth.auth().currentUser else {
            print("User not logged in to any account to update password")
            return
        }
        do {
            try await user.updatePassword(to: password)
        } catch {
            print("Error updating password: \(error)")
        }
    }

    func updateEmail(email: String) async {
        guard let user = Auth.auth().currentUser else {
            print("User not logged in to any account to update email")
            return
        }
        do {
            try await user.sendEmailVerification(beforeUpdatingEmail: email)
        } catch {
            print("Error updating email: \(error)")
        }
    }

    func signOut() throws {
        try Auth.auth().signOut()
    }

    func delete() async {
        guard let user = Auth.auth().currentUser else {
            print("User not logged in to any account to delete account")
            return
        }
        do {
            try await user.delete()
        } catch {
            print("Error deleting user: \(error)")
        }
    }
}
