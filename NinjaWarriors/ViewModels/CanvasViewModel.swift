//
//  CanvasViewModel.swift
//  NinjaWarriors
//
//  Created by Muhammad Reyaaz on 15/3/24.
//

import Foundation

// TODO: Allow init to take more ids other than playerids
@MainActor
final class CanvasViewModel: ObservableObject {
    @Published private(set) var players: [Player] = []
    @Published private(set) var manager: RealTimeManagerAdapter
    @Published private(set) var matchId: String
    @Published private(set) var playerIds: [String]
    @Published private(set) var currPlayerId: String

    init(matchId: String, playerIds: [String], currPlayerId: String) {
        self.matchId = matchId
        self.playerIds = playerIds
        self.currPlayerId = currPlayerId
        manager = RealTimeManagerAdapter()
    }

    // TODO: Change to add listener for all entities in match id
    func addListenerForPlayers() {
        Task { [weak self] in
            guard let self = self else { return }
            do {
                self.players = try await self.manager.getAllPlayers(with: playerIds)
                let publisher = self.manager.addListenerForAllPlayers()

                // TODO: Might be redundant
                publisher.subscribe(update: { players in
                    let filteredPlayers = players.filter { player in
                        self.playerIds.contains(player.id)
                    }
                    self.players = filteredPlayers.map { $0.toPlayer() }
                }, error: { error in
                    print(error)
                })

            } catch {
                print("Error fetching initial players: \(error)")
            }
        }
    }

    func changePosition(playerId: String, newPosition: CGPoint) {
        let newCenter = Point(xCoord: newPosition.x, yCoord: newPosition.y)

        if let index = players.firstIndex(where: { $0.id == playerId }) {
            players[index].changePosition(to: newCenter)
        }

        Task {
            try? await manager.updatePlayer(playerId: playerId, position: newCenter)
        }
    }
}
