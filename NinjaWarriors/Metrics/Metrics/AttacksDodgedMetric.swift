//
//  AttacksDodgedMetric.swift
//  NinjaWarriors
//
//  Created by Jivesh Mohan on 15/4/24.
//

import Foundation

class AttacksDodgedMetric: Metric {
    var title: String = "Attacks Dodged"
    var description: String = "The number of attacks successfully dodged by the player"
    var value: Double = 0
    var userID: UserID
    var inGameValue: Double = 0
    var lastGame: GameID? = nil

    required init(userID: UserID) {
        self.userID = userID
    }

    func update(with newValue: Double, for gameID: GameID?) {
        value += newValue

        guard let gameID = gameID else { return }
        inGameValue += newValue
        lastGame = gameID
    }
}
