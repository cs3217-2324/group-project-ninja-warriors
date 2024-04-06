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
        //Task { [unowned self] in
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
        //Task { [unowned self] in
            await self.matchManager.removePlayerFromMatch(playerId: userId, matchId: match)
        }
    }

    func start() async {
        guard let matchId = matchId else {
            return
        }
        realTimeManager = RealTimeManagerAdapter(matchId: matchId)
        do {
            playerIds = try await matchManager.startMatch(matchId: matchId)
        } catch {
            print("Error starting match: \(error)")
        }
        initEntities(ids: playerIds)
    }

    // Add all relevant initial entities here
    func initEntities(ids playerIds: [String]?) {
        for index in 0..<Constants.obstacleCount {
            addObstacleToDatabase(at: Constants.obstaclePositions[index])
        }

        addClosingZone(center: Constants.closingZonePosition, radius: Constants.closingZoneRadius)

        guard let playerIds = playerIds else {
            return
        }

        for (index, playerId) in playerIds.enumerated() {
            addPlayerToDatabase(id: playerId, at: Constants.playerPositions[index])
        }
    }

    private func addPlayerToDatabase(id playerId: String, at position: Point) {
        let player = makePlayer(id: playerId, at: position)
        guard let realTimeManager = realTimeManager else {
            return
        }
        Task {
            try? await realTimeManager.uploadEntity(entity: player)
        }
    }

    private func makePlayer(id playerId: String, at position: Point) -> Player {
        Player(id: playerId, position: position)
    }

    func getPlayerCount() -> Int? {
        if let match = matches.first(where: { $0.id == matchId }) {
            return match.count
        }
        return nil
    }

    private func addObstacleToDatabase(at position: Point) {
        let obstacle = makeObstacle(at: position)
        guard let realTimeManager = realTimeManager else {
            return
        }
        Task {
            try? await realTimeManager.uploadEntity(entity: obstacle)
        }
    }

    private func makeObstacle(at position: Point) -> Obstacle {
        Obstacle(id: RandomNonce().randomNonceString(), position: position)
    }

    private func addClosingZone(center: Point, radius: Double) {
        let closingZone = makeClosingZone(center: center, radius: radius)
        guard let realTimeManager = realTimeManager else {
            return
        }
        Task {
            try? await realTimeManager.uploadEntity(entity: closingZone, components: closingZone.getInitializingComponents())
        }
    }

    private func makeClosingZone(center: Point, radius: Double) -> ClosingZone {
        ClosingZone(id: RandomNonce().randomNonceString(), center: center, initialRadius: radius)
    }

    func addListenerForMatches() {
        let publisher = matchManager.addListenerForAllMatches()
        //publisher.subscribe(update: { [unowned self] matches in

        publisher.subscribe(update: { [weak self] matches in
            guard let self = self else { return }
            self.matches = matches.map { $0.toMatch() }
        }, error: { error in
            print(error)
        })
    }
}
