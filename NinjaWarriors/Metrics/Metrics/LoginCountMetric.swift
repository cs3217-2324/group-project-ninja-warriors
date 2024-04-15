//
//  LoginCountMetric.swift
//  NinjaWarriors
//
//  Created by Jivesh Mohan on 15/4/24.
//

import Foundation

class LoginCountMetric: Metric {
    var title: String = "Login Count"
    var description: String = "The number of times the player has logged in"
    var value: Double = 0
    var userID: UserID
    var inGameValue: Double = 0
    var lastGame: GameID? = nil

    required init(userID: UserID) {
        self.userID = userID
    }

    func update(with newValue: Double, for gameID: GameID?) {
        value += newValue
    }
}
