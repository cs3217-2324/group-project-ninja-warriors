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
            if let allEntities = try await self.manager.getAllEntities() {
                self.entities = allEntities
            }
            let publishers = self.manager.addListeners()
            for publisher in publishers {
                publisher.subscribe(update: { entities in
                    self.entities = entities.compactMap { $0.toEntity() }
                }, error: { error in
                    print(error)
                })
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
