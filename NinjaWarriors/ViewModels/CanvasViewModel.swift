//
//  CanvasViewModel.swift
//  NinjaWarriors
//
//  Created by Muhammad Reyaaz on 15/3/24.
//

import Foundation
import SwiftUI

@MainActor
final class CanvasViewModel: ObservableObject {
    var gameWorld: GameWorld
    private(set) var entities: [Entity] = []
    private(set) var entityImages: [String] = []
    private(set) var manager: EntitiesManager
    private(set) var matchId: String
    private(set) var currPlayerId: String
    var positions: [CGPoint]?

    init(matchId: String, currPlayerId: String) {
        self.matchId = matchId
        self.currPlayerId = currPlayerId
        self.manager = RealTimeManagerAdapter(matchId: matchId)
        self.gameWorld = GameWorld()

        gameWorld.start()
        gameWorld.updateViewModel = { [unowned self] in
            Task {
                await self.updateViewModel()
            }
        }
    }

    func updateViewModel() async {
        var rigidbodies = gameWorld.entityComponentManager.getAllComponents(ofType: Rigidbody.self)
        rigidbodies = rearrageRigidbodies(rigidbodies: rigidbodies)
        var rigidPositions: [CGPoint] = []

        for rigidbody in rigidbodies {
            rigidPositions.append(rigidbody.position.get())
        }
        positions = rigidPositions
        updateViews()
        await publishData()
    }

    // Since EntityComponentManager have unordered sets,
    // need to reorder based on entity index in entities
    func rearrageRigidbodies(rigidbodies: [Rigidbody]) -> [Rigidbody] {
        var rigidbodyMap = [EntityID: Rigidbody]()

        for rigidbody in rigidbodies {
            rigidbodyMap[rigidbody.entity.id] = rigidbody
        }
        var rearrangedRigidBodies = [Rigidbody]()

        // Rearrange the rigid bodies based on the order of the entities
        for entity in entities {
            if let rigidbody = rigidbodyMap[entity.id] {
                rearrangedRigidBodies.append(rigidbody)
            }
        }
        return rearrangedRigidBodies
    }

    // Only update positions that changed
    func updateViews() {
        objectWillChange.send()
    }

    func addListeners() {
        Task { [unowned self] in
            if let allEntities = try await self.manager.getAllEntities() {
                self.entities = allEntities
            }

            let publishers = self.manager.addPlayerListeners()

            /*
            let publishers = self.manager.addPlayerListeners()
            for publisher in publishers {
                publisher.subscribe(update: { [unowned self] entities in
                    self.entities = entities.compactMap { $0.toEntity() }
                }, error: { error in
                    print(error)
                })
            }
            */
            addEntitiesToWorld()
        }
    }

    func addEntitiesToWorld() {
        for entity in entities {
            gameWorld.entityComponentManager.add(entity: entity)

            if let spriteComponent = gameWorld.entityComponentManager.getComponent(ofType: Sprite.self, for: entity) {
                entityImages.append(spriteComponent.image)
            }
        }
    }

    func getCurrPlayer() -> Entity? {
        for entity in entities where entity.id == currPlayerId {
            return entity
        }
        return nil
    }

    // TODO: Find a way to obey law of demeter and upload all changed positions
    func publishData() async {
        guard let foundEntity = entities.first(where: { $0.id == currPlayerId }) else {
            print("No entity found with ID: \(currPlayerId)")
            return
        }

        try? await manager.uploadEntity(entity: foundEntity, entityName: "Player", component: gameWorld.entityComponentManager.getComponentFromId(ofType: Rigidbody.self, of: currPlayerId))

    }
}

extension CanvasViewModel {
    func activateSkill(forEntity entity: Entity, skillId: String) {
        let entityId = entity.id
        guard let skillCasterComponent = gameWorld.entityComponentManager
            .getComponentFromId(ofType: SkillCaster.self, of: entityId) else {
            print("No SkillCaster component found for entity with ID: \(entityId)")
            return
        }
//        print("[CanvasViewModel] \(skillId) queued for activation")
        skillCasterComponent.queueSkillActivation(skillId)
    }

    func getSkillIds(for entity: Entity) -> [String] {
        let entityId = entity.id
        let skillCaster = gameWorld.entityComponentManager
            .getComponentFromId(ofType: SkillCaster.self, of: entityId)
        
        if let skillCasterIds = skillCaster?.skills.keys {
//            print("skill caster ids: ", Array(skillCasterIds))
            return Array(skillCasterIds)
        } else {
            return []
        }
    }
    
    func getSkills(for entity: Entity) -> [Dictionary<SkillID, any Skill>.Element] {
        let entityId = entity.id
        let skillCaster = gameWorld.entityComponentManager
            .getComponentFromId(ofType: SkillCaster.self, of: entityId)
        
        if let skills = skillCaster?.skills {
            return Array(skills)
        } else {
            return []
        }
    }
}
