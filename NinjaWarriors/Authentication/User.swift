//
//  User.swift
//  NinjaWarriors
//
//  Created by Muhammad Reyaaz on 13/3/24.
//

import Foundation

struct User {
    let uid: String
    let email: String?

    init(uid: String, email: String?) {
        self.uid = uid
        self.email = email
    }
}
