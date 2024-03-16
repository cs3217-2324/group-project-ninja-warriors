//
//  SignInViewModel.swift
//  NinjaWarriors
//
//  Created by Muhammad Reyaaz on 13/3/24.
//

import Foundation

@MainActor
final class SignInViewModel: ObservableObject {

    @Published var email = ""
    @Published var password = ""
    @Published var user: User?
    private let authentication: Authentication

    init(authentication: Authentication) {
        self.authentication = authentication
    }

    func signUp() async throws {
        guard !email.isEmpty, !password.isEmpty else {
            print("No email or password found.")
            return
        }
        let user = try await authentication.signUp(email: email, password: password)
        self.user = user
        print("user", user)
    }

    func signIn() async throws {
        guard !email.isEmpty, !password.isEmpty else {
            print("No email or password found.")
            return
        }
        let user = try await authentication.signIn(email: email, password: password)
        self.user = user
        print("user", user)
    }

    func signOut() throws {
        try authentication.signOut()
    }
}
