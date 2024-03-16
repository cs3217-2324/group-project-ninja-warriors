//
//  MatchManager.swift
//  NinjaWarriors
//
//  Created by Muhammad Reyaaz on 16/3/24.
//

import Foundation

protocol MatchManager {
    func createMatch() async throws -> String
    func addPlayerToMatch(playerId: String, matchId: String) async
    func removePlayerFromMatch(playerId: String, matchId: String) async
}
