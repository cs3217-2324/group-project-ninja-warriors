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

    init() {
        manager = PlayersManagerAdapter()
        addPlayers()
    }

    // TODO: Remove hardcoded players
    func addPlayers() {
        let gameObject1 = GameObject(center: Point(xCoord: 150.0, yCoord: 150.0), halfLength: 25.0)
        let gameObject2 = GameObject(center: Point(xCoord: 200.0, yCoord: 150.0), halfLength: 25.0)
        let gameObject3 = GameObject(center: Point(xCoord: 250.0, yCoord: 150.0), halfLength: 25.0)
        let gameObject4 = GameObject(center: Point(xCoord: 300.0, yCoord: 150.0), halfLength: 25.0)

        let player1 = Player(id: 0, gameObject: gameObject1)
        let player2 = Player(id: 1, gameObject: gameObject2)
        let player3 = Player(id: 2, gameObject: gameObject3)
        let player4 = Player(id: 3, gameObject: gameObject4)

        players.append(player1)
        players.append(player2)
        players.append(player3)
        players.append(player4)

        Task {
            try? await manager.uploadPlayer(player: player1)
            try? await manager.uploadPlayer(player: player2)
            try? await manager.uploadPlayer(player: player3)
            try? await manager.uploadPlayer(player: player4)
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
        guard let id = Int(playerId) else {
            return
        }
        let newCenter = Point(xCoord: newPosition.x, yCoord: newPosition.y)
        players[id].changePosition(to: newCenter)

        Task {
            try? await manager.updatePlayer(playerId: playerId, position: newCenter)
        }
    }
}
