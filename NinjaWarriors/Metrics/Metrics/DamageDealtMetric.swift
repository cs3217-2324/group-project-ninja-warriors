//
//  TotalDamageDealtMetric.swift
//  NinjaWarriors
//
//  Created by Jivesh Mohan on 10/4/24.
//

import Foundation

class DamageDealtMetric: Metric {
    let title: String = "Damage Dealt"
    let description: String = "The amount of damage done by this player."
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
