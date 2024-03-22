//
//  CanvasViewModel.swift
//  NinjaWarriors
//
//  Created by Muhammad Reyaaz on 15/3/24.
//

import Foundation

@MainActor
final class CanvasViewModel: ObservableObject {
    @Published var gameWorld = GameWorld()
    @Published private(set) var entities: [Entity] = []
    @Published private(set) var manager: RealTimeManagerAdapter
    @Published private(set) var matchId: String
    @Published private(set) var currPlayerId: String

    init(matchId: String, currPlayerId: String) {
        self.matchId = matchId
        self.currPlayerId = currPlayerId
        manager = RealTimeManagerAdapter(matchId: matchId)
        gameWorld.start()
    }

    func addListeners() {
        Task { [weak self] in
            guard let self = self else { return }
            if let allEntities = try await self.manager.getAllEntities() {
                print("all entities", allEntities)
                self.entities = allEntities
            }

            // TODO: Find a way to add listeners in one go
            let publishers = self.manager.addPlayerListeners()
            for publisher in publishers {
                publisher.subscribe(update: { entities in
                    self.entities = entities.compactMap { $0.toEntity() }
                }, error: { error in
                    print(error)
                })
            }
        }
    }

    // TODO: Change to game loop and systems
    func changePosition(entityId: String, newPosition: CGPoint) {
        let newCenter = Point(xCoord: newPosition.x, yCoord: newPosition.y)

        if let index = entities.firstIndex(where: { $0.id == entityId }) {
            let entity = entities[index]
            entity.shape.center.setCartesian(xCoord: newPosition.x, yCoord: newPosition.y)
        }
        Task {
            try? await manager.updateEntity(id: entityId, position: newCenter)
        }
    }
}
