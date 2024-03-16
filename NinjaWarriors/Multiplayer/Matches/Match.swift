//
//  Match.swift
//  NinjaWarriors
//
//  Created by Muhammad Reyaaz on 16/3/24.
//

import Foundation

class Match {
    let id: String
    let count: Int
    let readyPlayers: [Int]

    init(id: String, count: Int, readyPlayers: [Int]) {
        self.id = id
        self.count = count
        self.readyPlayers = readyPlayers
    }

    func toMatchWrapper() -> MatchWrapper {
        MatchWrapper(id: id, count: count, readyPlayers: readyPlayers)
    }
}
