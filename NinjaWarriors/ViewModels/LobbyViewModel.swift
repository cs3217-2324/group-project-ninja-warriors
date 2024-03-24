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
    // @Published private(set) var systemManager: SystemManager
    @Published var matchId: String?
    @Published var playerIds: [String]?

    init() {
        matchManager = MatchManagerAdapter()
        // systemManager = SystemManager()
    }

    func ready(userId: String) {
        Task { [weak self] in
            guard let self = self else { return }
            let newMatchId = try await matchManager.enterQueue(playerId: userId)
            self.matchId = newMatchId
            addListenerForMatches()
        }
    }

    func unready(userId: String) {
        guard let match = matchId else {
            return
        }
        Task { [weak self] in
            guard let self = self else { return }
            await self.matchManager.removePlayerFromMatch(playerId: userId, matchId: match)
        }
    }

    func start() async throws {
        guard let matchId = matchId else {
            return
        }
        realTimeManager = RealTimeManagerAdapter(matchId: matchId)
        playerIds = try await matchManager.startMatch(matchId: matchId)
        initPlayers(ids: playerIds)
    }

    // Add all relevant entities here
    func initPlayers(ids playerIds: [String]?) {
        guard let playerIds = playerIds else {
            return
        }
        for (index, playerId) in playerIds.enumerated() {
            addPlayerToDatabase(id: playerId, position: Constants.playerPositions[index])
        }
    }

    private func addPlayerToDatabase(id playerId: String, position: Point) {
        let player = makePlayer(id: playerId, position: position)
        guard let realTimeManager = realTimeManager else {
            return
        }
        Task {
            try? await realTimeManager.uploadEntity(entity: player, entityName: "Player")
        }
    }

    private func makePlayer(id playerId: String, position: Point) -> Player {
        let shape = Shape(center: position, halfLength: Constants.defaultSize)
        let player = Player(id: playerId, shape: shape)

        return player
    }

    func getPlayerCount() -> Int? {
        if let match = matches.first(where: { $0.id == matchId }) {
            return match.count
        }
        return nil
    }

    func addListenerForMatches() {
        let publisher = matchManager.addListenerForAllMatches()
        publisher.subscribe(update: { [weak self] matches in
            self?.matches = matches.map { $0.toMatch() }
        }, error: { error in
            print(error)
        })
    }
}
