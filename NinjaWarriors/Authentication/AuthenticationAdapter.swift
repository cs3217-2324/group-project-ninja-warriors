//
//  AuthenticationAdapter.swift
//  NinjaWarriors
//
//  Created by Muhammad Reyaaz on 13/3/24.
//

import Foundation
import FirebaseAuth

final class AuthenticationAdapter: Authentication {

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

    func signOut() throws {
        try Auth.auth().signOut()
    }

    func delete() async throws {
        guard let user = Auth.auth().currentUser else {
            throw URLError(.badURL)
        }

        try await user.delete()
    }
}
