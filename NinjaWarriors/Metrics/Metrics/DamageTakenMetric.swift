//
//  DamageTakenMetric.swift
//  NinjaWarriors
//
//  Created by Jivesh Mohan on 14/4/24.
//

import Foundation

class DamageTakenMetric: Metric {
    let title: String = "Damage Taken"
    let description: String = "The amount of damage taken by this player."
    var value: Double
    var userID: UserID
    var inGameValue: Double
    var lastGame: GameID?

    required init(userID: UserID) {
        self.value = 0
        self.userID = userID
        self.inGameValue = 0
    }

    func update(with newValue: Double, for gameID: GameID?) {
        self.value += newValue

        guard let gameID = gameID else { return }

        self.inGameValue += newValue

        self.lastGame = gameID
    }
}
