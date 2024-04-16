//
//  Metric.swift
//  NinjaWarriors
//
//  Created by Jivesh Mohan on 10/4/24.
//

import Foundation

typealias GameID = String
protocol Metric: AnyObject {
    var title: String { get }
    var description: String { get }
    var value: Double { get set }
    var userID: UserID { get }
    var inGameValue: Double { get set }
    var lastGame: GameID? { get set }

    func update(with newValue: Double, for gameID: GameID?)
    init(userID: UserID)
}

extension Metric {
    func resetGame() {
        self.inGameValue = 0
        self.lastGame = nil
    }
}
