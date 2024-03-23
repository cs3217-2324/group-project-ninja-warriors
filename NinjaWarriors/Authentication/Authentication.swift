//
//  Authentication.swift
//  NinjaWarriors
//
//  Created by Muhammad Reyaaz on 13/3/24.
//

import Foundation

protocol Authentication {
    func signIn(email: String, password: String) async throws -> User
    func signUp(email: String, password: String) async throws -> User
    func getAuthenticatedUser() throws -> User
    func updateEmail(email: String) async throws
    func updatePassword(password: String) async throws
    func resetPassword(email: String) async throws
    func signOut() throws
    func delete() async throws
}
