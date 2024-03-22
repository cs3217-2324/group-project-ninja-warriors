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
    func addListenerForAllMatches() -> MatchPublisher
    func enterQueue(playerId: String) async throws -> String
    func getMatchCount(matchId: String) async throws -> Int?
    func getMatch(limit: Int) async throws -> String?
    func getMatchBelowLimit(limit: Int) async throws -> String?
    func startMatch(matchId: String) async throws -> [String]?
}
