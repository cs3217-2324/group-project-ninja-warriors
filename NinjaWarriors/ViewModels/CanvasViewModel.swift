//
//  CanvasViewModel.swift
//  NinjaWarriors
//
//  Created by Muhammad Reyaaz on 15/3/24.
//

import Foundation

@MainActor
final class CanvasViewModel: ObservableObject {
    @Published private(set) var entities: [Entity] = []
    @Published private(set) var manager: RealTimeManagerAdapter
    @Published private(set) var matchId: String
    @Published private(set) var currPlayerId: String

    init(matchId: String, currPlayerId: String) {
        self.matchId = matchId
        self.currPlayerId = currPlayerId
        manager = RealTimeManagerAdapter(matchId: matchId)
    }

    func addListenerForPlayers() {
        Task { [weak self] in
            guard let self = self else { return }
            do {
                if let allEntities = try await self.manager.getAllEntities() {
                    print("all entities", allEntities)
                    self.entities = allEntities
                }

                // let publisher = self.manager.addListenerForAllPlayers()
                let publisher = self.manager.addListenerForAllEntities()
                // TODO: Might be redundant
                /*
                publisher.subscribe(update: { entities in
                    let filteredPlayers = entities.filter { player in
                        self.playerIds.contains(player.id)
                    }
                    // self.entities = filteredPlayers.map { $0.toEntity() }
                    self.entities = filteredPlayers.compactMap {
                        guard let entity = $0.toEntity() else {
                            return
                        }
                        return entity
                    }

                }, error: { error in
                    print(error)
                })
                */

                publisher.subscribe(update: { entities in
                    // Update your view with all entities received
                    self.entities = entities.compactMap { $0.toEntity() }
                    print("self entities", self.entities)
                }, error: { error in
                    print(error)
                })

            } catch {
                print("Error fetching initial entities: \(error)")
            }
        }
    }

    func changePosition(entityId: String, newPosition: CGPoint) {
        let newCenter = Point(xCoord: newPosition.x, yCoord: newPosition.y)

        if let index = entities.firstIndex(where: { $0.id == entityId }) {
            var entity = entities[index]
            entity.shape.center.setCartesian(xCoord: newPosition.x, yCoord: newPosition.y)
        }
        Task {
            try? await manager.updateEntity(id: entityId, position: newCenter)
        }
    }
}
