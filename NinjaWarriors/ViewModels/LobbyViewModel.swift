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
    @Published private(set) var manager: MatchManager
    @Published private(set) var playersManager: PlayersManager
    @Published private(set) var realTimePlayersManager: RealTimePlayersManagerAdapter
    @Published var matchId: String?
    @Published var playerCount: Int?
    @Published var players: [String]?

    init() {
        manager = MatchManagerAdapter()
        playersManager = PlayersManagerAdapter()
        realTimePlayersManager = RealTimePlayersManagerAdapter()
    }

    func ready(userId: String) {
        Task {
            do {
                let newMatchId = try await manager.enterQueue(playerId: userId)
                addListenerForMatches()
                DispatchQueue.main.async { [weak self] in
                    guard let self = self else { return }
                    self.matchId = newMatchId
                }
            } catch {
                print("Error entering queue: \(error)")
            }
        }
        addPlayer(playerId: userId)
    }

    func unready(userId: String) {
        guard let match = matchId else {
            return
        }
        Task { [weak self] in
            guard let self = self else { return }
            await self.manager.removePlayerFromMatch(playerId: userId, matchId: match)
        }
    }

    func start() async {
        guard let matchId = matchId else {
            return
        }
        do {
            let result = try await manager.startMatch(matchId: matchId)
            self.players = result
        } catch {
            print("Error starting match: \(error)")
        }
    }

    // TODO: Remove hardcoded value
    func addPlayer(playerId: String) {
        let gameObject1 = GameObject(center: Point(xCoord: 150.0 + Double.random(in: -150.0...150.0),
                                                   yCoord: 150.0), halfLength: 25.0)
        let player1 = Player(id: playerId, gameObject: gameObject1)
        Task {
            try? await playersManager.uploadPlayer(player: player1)
            try? await realTimePlayersManager.uploadPlayer(player: player1)
        }
    }

    func getPlayerCount() -> Int? {
        if let match = matches.first(where: { $0.id == matchId }) {
            return match.count
        }
        return nil
    }

    func addListenerForMatches() {
        let publisher = manager.addListenerForAllMatches()
        publisher.subscribe(update: { [weak self] matches in
            self?.matches = matches.map { $0.toMatch() }
        }, error: { error in
            print(error)
        })
    }
}
