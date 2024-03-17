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

    init() {
        manager = PlayersManagerAdapter()
        getPlayers()
    }

    func getPlayers() {
        Task { [weak self] in
            guard let self = self else { return }
            do {
                self.players = try await self.manager.getAllPlayers()
            } catch {
                print("Error fetching players: \(error)")
            }
        }
    }

    func addListenerForPlayers() {
        let publisher = manager.addListenerForAllPlayers()
        publisher.subscribe(update: { [weak self] players in
            self?.players = players.map { $0.toPlayer() }
        }, error: { error in
            print(error)
        })
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
