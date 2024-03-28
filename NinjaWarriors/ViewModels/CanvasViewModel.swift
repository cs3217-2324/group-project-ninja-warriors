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
    @Published private(set) var position: CGPoint? /*= CGPoint(x: 400.0, y: 400.0)*/

    init(matchId: String, currPlayerId: String) {
        self.matchId = matchId
        self.currPlayerId = currPlayerId
        manager = RealTimeManagerAdapter(matchId: matchId)

        gameWorld.start()
        gameWorld.updateViewModel = { [unowned self] in
            self.updateViewModel()
        }
    }

    func updateViewModel() {
        // TODO: Tidy up to obey law of demeter
        print(gameWorld.entityComponentManager.getComponentFromId(ofType: Rigidbody.self, of: currPlayerId)?.position)

        position = gameWorld.entityComponentManager.getComponentFromId(ofType: Rigidbody.self, of: currPlayerId)?.position.get()

        gameWorld.systemManager.update(after: 1/60)
        //publishData()
    }

    func addListeners() {
        Task { [unowned self] in
            if let allEntities = try await self.manager.getAllEntities() {
                self.entities = allEntities
            }

            let publishers = self.manager.addPlayerListeners()
            for publisher in publishers {
                publisher.subscribe(update: { [unowned self] entities in
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

    func publishData() {
        guard let position = position else {
            return
        }
        let newCenter = Point(xCoord: Double(position.x), yCoord: Double(position.y))
        Task {
            try? await manager.updateEntity(id: currPlayerId, position: newCenter)
        }
    }

    /*
    // TODO: Deprecate
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
    */
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
    
    func getSkills(for entityId: String) -> [Dictionary<SkillID, any Skill>.Element] {
        let skillCaster = gameWorld.entityComponentManager
            .getComponentFromId(ofType: SkillCaster.self, of: entityId)
        
        if let skills = skillCaster?.skills {
            return Array(skills)
        } else {
            return []
        }
    }
}
