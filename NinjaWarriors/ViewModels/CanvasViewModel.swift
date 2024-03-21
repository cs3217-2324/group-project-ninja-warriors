//
//  CanvasViewModel.swift
//  NinjaWarriors
//
//  Created by Muhammad Reyaaz on 15/3/24.
//

import Foundation

@MainActor
final class CanvasViewModel: ObservableObject {
    // @Published private(set) var players: [Player] = []
    @Published private(set) var players: [Entity] = []
    @Published private(set) var manager: RealTimeManagerAdapter
    @Published private(set) var matchId: String
    // @Published private(set) var playerIds: [String]
    @Published private(set) var currPlayerId: String

    init(matchId: String, entities: [Entity], currPlayerId: String) {
        self.matchId = matchId
        self.players = entities
        // self.playerIds = playerIds
        self.currPlayerId = currPlayerId
        manager = RealTimeManagerAdapter(matchId: matchId)
    }

    // TODO: Change to add listener for all entities in match id
    func addListenerForPlayers() {
        Task { [weak self] in
            guard let self = self else { return }
            do {
                if let allEntities = try await self.manager.getAllEntities() {
                    print("all entities", allEntities)
                    self.players = allEntities
                }

                // let publisher = self.manager.addListenerForAllPlayers()
                let publisher = self.manager.addListenerForAllEntities()
                // TODO: Might be redundant
                /*
                publisher.subscribe(update: { players in
                    let filteredPlayers = players.filter { player in
                        self.playerIds.contains(player.id)
                    }
                    // self.players = filteredPlayers.map { $0.toEntity() }
                    self.players = filteredPlayers.compactMap {
                        guard let entity = $0.toEntity() else {
                            return
                        }
                        return entity
                    }

                }, error: { error in
                    print(error)
                })
                */

                publisher.subscribe(update: { players in
                    // Update your view with all players received
                    self.players = players.compactMap { $0.toEntity() }
                    print("self players", self.players)
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
            guard var player = players[index] as? Player else {
                return
            }
            player.changePosition(to: newCenter)
        }

        Task {
            try? await manager.updateEntity(id: playerId, position: newCenter, entityType: "Player")
        }
    }
}
