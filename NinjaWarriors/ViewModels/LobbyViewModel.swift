//
//  LobbyViewModel.swift
//  NinjaWarriors
//
//  Created by Muhammad Reyaaz on 16/3/24.
//

import Foundation
import SwiftUI

// TODO: Rename PlayersManager and methods to just EntitiesManager
// TODO: Create mapping from match id to map id to know what other entities to add
@MainActor
final class LobbyViewModel: ObservableObject {
    @Published private(set) var matches: [Match] = []
    @Published private(set) var matchManager: MatchManager
    @Published private(set) var realTimeManager: RealTimeManagerAdapter
    @Published private(set) var systemManager: SystemManager
    @Published var matchId: String?
    @Published var playerIds: [String]?

    init() {
        matchManager = MatchManagerAdapter()
        realTimeManager = RealTimeManagerAdapter()
        systemManager = SystemManager()
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

    // TODO: Abstract out start to loading of all entities in map
    func start() async throws {
        guard let matchId = matchId else {
            return
        }
        playerIds = try await matchManager.startMatch(matchId: matchId)
        initSystems(ids: playerIds)
    }

    // Add all relevant entities and systems related to map here
    func initSystems(ids playerIds: [String]?) {
        
        addPlayersToSystemAndDatabase(ids: playerIds)

    }

    private func addPlayersToSystemAndDatabase(ids playerIds: [String]?) {
        guard let playerIds = playerIds else {
            return
        }
        for playerId in playerIds {
            addPlayerToSystemAndDatabase(id: playerId)
        }
    }

    // TODO: Remove hardcoded value
    private func addPlayerToSystemAndDatabase(id playerId: String) {
        let Shape = Shape(center: Point(xCoord: 150.0 + Double.random(in: -150.0...150.0),
                                                   yCoord: 150.0), halfLength: 25.0)
        let dashSkill = DashSkill(id: "1")
        let player = Player(id: playerId, Shape: Shape, skills: [dashSkill])
        Task {
            try? await realTimeManager.uploadPlayer(player: player)
        }
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
