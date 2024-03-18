//
//  PlayersManagerAdapter.swift
//  NinjaWarriors
//
//  Created by Muhammad Reyaaz on 16/3/24.
//

import Foundation

protocol PlayersManager {
    func uploadPlayer(player: Player) async throws
    func getPlayer(playerId: String) async throws -> Player
    func updatePlayer(playerId: String, position: Point) async throws
    func getAllPlayers(with playerIds: [String]) async throws -> [Player]
    func addListenerForAllPlayers() -> PlayerPublisher
}
