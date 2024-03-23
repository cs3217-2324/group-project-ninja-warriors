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
        gameWorld.updateViewModel = { [weak self] in
            self?.updateViewModel()
        }
    }

    func updateViewModel() {
        gameWorld.systemManager.update(after: 1/60) // TODO: probably refactor this to match update loop
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
            addEntitiesToWorld()
        }
    }

    func addEntitiesToWorld() {
        for entity in entities {
            gameWorld.entityComponentManager.add(entity: entity)
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

extension CanvasViewModel {
    func activateSkill(forEntityWithId entityId: String, skillId: String) {
        guard let skillCasterComponent = gameWorld.entityComponentManager
            .getComponentFromId(ofType: SkillCaster.self, of: entityId) else {
            print("No SkillCaster component found for entity with ID: \(entityId)")
            return
        }

        print("[CanvasViewModel] \(skillId) queued for activation")
        skillCasterComponent.queueSkillActivation(skillId)
    }

    func getSkillIds(for entityId: String) -> [String] {
        // This method assumes we have a way to retrieve the SkillCaster component
        // and then fetch the skill IDs from it. For simplicity, here's a placeholder:
        return ["skill1", "skill2"] // TODO: remove hardcode
    }
}
