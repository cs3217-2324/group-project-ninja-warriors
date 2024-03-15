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

    // TODO: Remove hardcoded players
    func addPlayers() {
        let gameObject1 = GameObject(center: Point(xCoord: 150.0, yCoord: 150.0), halfLength: 25.0)
        let gameObject2 = GameObject(center: Point(xCoord: 200.0, yCoord: 150.0), halfLength: 25.0)
        let gameObject3 = GameObject(center: Point(xCoord: 250.0, yCoord: 150.0), halfLength: 25.0)
        let gameObject4 = GameObject(center: Point(xCoord: 300.0, yCoord: 150.0), halfLength: 25.0)

        let player1 = Player(id: 1, gameObject: gameObject1)
        let player2 = Player(id: 2, gameObject: gameObject2)
        let player3 = Player(id: 3, gameObject: gameObject3)
        let player4 = Player(id: 4, gameObject: gameObject4)

        players.append(player1)
        players.append(player2)
        players.append(player3)
        players.append(player4)
    }
}
