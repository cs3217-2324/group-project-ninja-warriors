//
//  GamesPlayedMetric.swift
//  NinjaWarriors
//
//  Created by Jivesh Mohan on 10/4/24.
//

import Foundation

class GamesPlayedMetric: Metric {
    let title: String = "Games Played"
    let description: String = "The number of games played by this player."
    var value: Double
    var userID: UserID
    var inGameValue: Double = 0
    var lastGame: GameID?

    required init(userID: UserID) {
        self.value = 0
        self.userID = userID
    }

    func update(with newValue: Double, for gameID: GameID?) {
        self.value += newValue
    }
}
