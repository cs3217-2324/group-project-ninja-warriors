//
//  LobbyViewModel.swift
//  NinjaWarriors
//
//  Created by Muhammad Reyaaz on 16/3/24.
//

import Foundation
import SwiftUI

@MainActor
final class LobbyViewModel: ObservableObject {
    @Published private(set) var matches: [Match] = []
    @Published private(set) var matchManager: MatchManager
    @Published private(set) var realTimeManager: RealTimeManagerAdapter?
    @Published var matchId: String?
    @Published var playerIds: [String]?

    init() {
        matchManager = MatchManagerAdapter()
    }

    func ready(userId: String) {
        Task { [unowned self] in
            let newMatchId = try await matchManager.enterQueue(playerId: userId)
            self.matchId = newMatchId
            addListenerForMatches()
        }
    }

    func unready(userId: String) {
        guard let match = matchId else {
            return
        }
        Task { [unowned self] in
            await self.matchManager.removePlayerFromMatch(playerId: userId, matchId: match)
        }
    }

    func start() async throws {
        guard let matchId = matchId else {
            return
        }
        realTimeManager = RealTimeManagerAdapter(matchId: matchId)
        playerIds = try await matchManager.startMatch(matchId: matchId)
        initEntities(ids: playerIds)
    }

    // Add all relevant initial entities here
    func initEntities(ids playerIds: [String]?) {
        for _ in 0...4 {
            addObstacleToDatabase()
        }

        guard let playerIds = playerIds else {
            return
        }
        //playerIds.append("opponent")
        for playerId in playerIds {
            addPlayerToDatabase(id: playerId)
        }
    }

    private func addPlayerToDatabase(id playerId: String) {
        let player = makePlayer(id: playerId)
        guard let realTimeManager = realTimeManager else {
            return
        }
        Task {
            try? await realTimeManager.uploadEntity(entity: player, entityName: "Player")
        }
    }

    private func makePlayer(id playerId: String) -> Player {
        let player = Player(id: playerId)

        return player
    }

    func getPlayerCount() -> Int? {
        if let match = matches.first(where: { $0.id == matchId }) {
            return match.count
        }
        return nil
    }

    private func addObstacleToDatabase() {
        let obstacle = makeObstacle()
        guard let realTimeManager = realTimeManager else {
            return
        }
        Task {
            try? await realTimeManager.uploadEntity(entity: obstacle, entityName: "Obstacle")
        }
    }

    private func makeObstacle() -> Obstacle {
        Obstacle(id: RandomNonce().randomNonceString())
    }

    func addListenerForMatches() {
        let publisher = matchManager.addListenerForAllMatches()
        publisher.subscribe(update: { [unowned self] matches in
            self.matches = matches.map { $0.toMatch() }
        }, error: { error in
            print(error)
        })
    }
}
