//
//  LobbyViewModel.swift
//  NinjaWarriors
//
//  Created by Muhammad Reyaaz on 16/3/24.
//

import Foundation
import SwiftUI

// TODO: Rename EntitiesManager and methods to just EntitiesManager
// TODO: Create mapping from match id to map id to know what other entities to add
@MainActor
final class LobbyViewModel: ObservableObject {
    @Published private(set) var matches: [Match] = []
    @Published private(set) var matchManager: MatchManager
    @Published private(set) var realTimeManager: RealTimeManagerAdapter
    @Published private(set) var systemManager: SystemManager
    // TODO: Remove entities. Passing entites before game start will not work since entities can get created during the game as well
    @Published private(set) var entities: [Entity]
    @Published var matchId: String?
    @Published var playerIds: [String]?

    init() {
        matchManager = MatchManagerAdapter()
        realTimeManager = RealTimeManagerAdapter()
        systemManager = SystemManager()
        entities = []
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
        for (index, playerId) in playerIds.enumerated() {
            addPlayerToSystemAndDatabase(id: playerId, position: Constants.playerPositions[index])
        }
    }

    private func addPlayerToSystemAndDatabase(id playerId: String, position: Point) {
        let player = makePlayer(id: playerId, position: position)
        Task {
            try? await realTimeManager.uploadEntity(entity: player)
        }
        entities.append(player)
    }

    private func makePlayer(id playerId: String, position: Point) -> Player {
        let randomNonce = RandomNonce().randomNonceString()
        let shape = Shape(center: position, halfLength: Constants.defaultSize)
        let player = Player(id: playerId, shape: shape)
        // shape.entity = player
        return player
    }

    /*
    // TODO: Rename uploadPlayer to uploadEntity
    private func addEntityToDatabase(entity: Entity) {
        Task {
            try? await realTimeManager.uploadPlayer(player: entity)
        }
    }
    */

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
