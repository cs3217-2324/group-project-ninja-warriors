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
    func signOut() throws
}
