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
    @Published private(set) var testManager: PlayersTest = PlayersTest()

    init(matchId: String, playerIds: [String]) {
        self.matchId = matchId
        self.playerIds = playerIds
        manager = PlayersManagerAdapter()
    }

    func addListenerForPlayers() {
        Task { [weak self] in
            guard let self = self else { return }
            do {
                //self.players = try await self.testManager.getAllPlayers(with: playerIds)
                self.players = try await self.testManager.getAllPlayers()
                //print("canvas players", self.players)
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

    /*
    func addListenerForPlayers() {
        Task { [weak self] in
            guard let self = self else { return }
            do {
                self.players = try await self.manager.getAllPlayers(with: playerIds)
                let publisher = self.manager.addListenerForAllPlayers()
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
    */

    ///*
    func changePosition(playerId: String, newPosition: CGPoint) {
        let newCenter = Point(xCoord: newPosition.x, yCoord: newPosition.y)

        if let index = players.firstIndex(where: { $0.id == playerId }) {
            players[index].changePosition(to: newCenter)
        }

        Task {
            try? await testManager.updatePlayer(playerId: playerId, position: newCenter)
        }
    }
    //*/

    /*
    func changePosition(playerId: String, newPosition: CGPoint) {
        print("changing position of", playerId)
        let newCenter = Point(xCoord: newPosition.x, yCoord: newPosition.y)

        if let index = players.firstIndex(where: { $0.id == playerId }) {
            players[index].changePosition(to: newCenter)
        }

        let startTime = DispatchTime.now() // Capture the start time

        Task {
            do {
                try await testManager.updatePlayer(playerId: playerId, position: newCenter)

                // Capture the end time and calculate the execution duration
                let endTime = DispatchTime.now()
                let executionTime = endTime.uptimeNanoseconds - startTime.uptimeNanoseconds
                //print("Task executed in \(Double(executionTime) / 1_000_000_000) seconds")
            } catch {
                print("Error updating player: \(error)")
            }
        }
    }
    */
}
