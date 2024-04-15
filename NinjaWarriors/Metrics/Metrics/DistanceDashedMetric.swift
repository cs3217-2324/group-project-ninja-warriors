//
//  DistanceDashedMetric.swift
//  NinjaWarriors
//
//  Created by Jivesh Mohan on 14/4/24.
//

import Foundation

class DistanceDashedMetric: Metric {
    let title: String = "Distance Dashed"
    let description: String = "The total distance dashed by this player."
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