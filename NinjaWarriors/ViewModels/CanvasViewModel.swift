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
    @Published private(set) var gameControl: GameControl

    init(matchId: String, currPlayerId: String, gameControl: GameControl = JoystickControl()) {
        self.matchId = matchId
        self.currPlayerId = currPlayerId
        self.gameControl = gameControl
        manager = RealTimeManagerAdapter(matchId: matchId)

        gameWorld.start()
        gameWorld.updateViewModel = { [weak self] in
            self?.updateViewModel()
        }
    }

    func updateViewModel() {
        gameWorld.systemManager.update(after: 1/60)
    }

    func addListeners() {
        Task { [weak self] in
            guard let self = self else { return }
            if let allEntities = try await self.manager.getAllEntities() {
                self.entities = allEntities
            }

            let publishers = self.manager.addPlayerListeners()
            for publisher in publishers {
                publisher.subscribe(update: { [weak self] entities in
                    guard let self = self else { return }
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

    func changePosition(newPosition: CGPoint) {
        let newCenter = Point(xCoord: newPosition.x, yCoord: newPosition.y)

        if let index = entities.firstIndex(where: { $0.id == currPlayerId }) {
            let entity = entities[index]
            entity.shape.center.setCartesian(xCoord: newPosition.x, yCoord: newPosition.y)
        }
        Task {
            try? await manager.updateEntity(id: currPlayerId, position: newCenter)
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
//        print("[CanvasViewModel] \(skillId) queued for activation")
        skillCasterComponent.queueSkillActivation(skillId)
    }

    func getSkillIds(for entityId: String) -> [String] {
        let skillCaster = gameWorld.entityComponentManager
            .getComponentFromId(ofType: SkillCaster.self, of: entityId)
        
        if let skillCasterIds = skillCaster?.skills.keys {
//            print("skill caster ids: ", Array(skillCasterIds))
            return Array(skillCasterIds)
        } else {
            return []
        }
    }
}
