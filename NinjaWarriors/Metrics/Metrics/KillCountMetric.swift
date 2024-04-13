//
//  KillCountMetric.swift
//  NinjaWarriors
//
//  Created by Jivesh Mohan on 10/4/24.
//

import Foundation

class KillCountMetric: Metric {
    let title: String = "Total Kill Count"
    let description: String = "The total number of enemies killed in all games."
    var value: Double
    var userID: UserID
    var inGameValues: [GameID : Double] = [:]
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

        self.inGameValues[gameID, default: 0] += newValue
    }
}
