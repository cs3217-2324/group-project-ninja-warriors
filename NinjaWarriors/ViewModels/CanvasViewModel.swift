//
//  CanvasViewModel.swift
//  NinjaWarriors
//
//  Created by Muhammad Reyaaz on 15/3/24.
//

import Foundation

@MainActor
final class CanvasViewModel: ObservableObject {
    @Published private(set) var players: [Player] = []
    @Published private(set) var manager: PlayersManager
    @Published private(set) var matchId: String
    @Published private(set) var playerIds: [String]
    @Published private(set) var testManager: RealTimePlayersManagerAdapter = RealTimePlayersManagerAdapter()

    init(matchId: String, playerIds: [String]) {
        self.matchId = matchId
        self.playerIds = playerIds
        manager = PlayersManagerAdapter()
    }

    func addListenerForPlayers() {
        Task { [weak self] in
            guard let self = self else { return }
            do {
                self.players = try await self.testManager.getAllPlayers()
                let publisher = self.testManager.addListenerForAllPlayers()
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
            try? await testManager.updatePlayer(playerId: playerId, position: newCenter)
        }
    }
}
