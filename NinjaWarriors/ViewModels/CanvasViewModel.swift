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
        self.gameWorld = GameWorld(for: matchId)

        gameWorld.start()
        gameWorld.updateViewModel = { [unowned self] in
            Task {
                await self.updateViewModel()
            }
        }
    }

    func updateViewModel() async {
        updatePositions()
        updateViews()
        //await publishData()

        do {
            try await publishData()
        } catch {
            print("Error publishing data: \(error)")
        }
    }

    func updatePositions() {
        var rigidbodies = gameWorld.entityComponentManager.getAllComponents(ofType: Rigidbody.self)
        rigidbodies = rearrageRigidbodies(rigidbodies: rigidbodies)
        var rigidPositions: [CGPoint] = []

        for rigidbody in rigidbodies {
            rigidPositions.append(rigidbody.position.get())
        }
        positions = rigidPositions
    }

    // Since EntityComponentManager have unordered sets, need to reorder based on entity index in entities
    func rearrageRigidbodies(rigidbodies: [Rigidbody]) -> [Rigidbody] {
        var rigidbodyMap = [EntityID: Rigidbody]()

        for rigidbody in rigidbodies {
            rigidbodyMap[rigidbody.entity.id] = rigidbody
        }
        var rearrangedRigidBodies = [Rigidbody]()

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

            //let publishers = self.manager.addPlayerListeners()

            ///*
            let publishers = self.manager.addPlayerListeners()
            for publisher in publishers {
                publisher.subscribe(update: { [unowned self] entities in
                    self.entities = entities.compactMap { $0.toEntity() }
                    //print("changed")
                }, error: { error in
                    print(error)
                })
            }
            //*/
            addEntitiesToWorld()
        }
    }

    // TODO: Only allow host to add entities to world
    func addEntitiesToWorld() {
        for entity in entities {
            gameWorld.entityComponentManager.add(entity: entity)

            if let spriteComponent = gameWorld.entityComponentManager.getComponent(ofType: Sprite.self,
                                                                                   for: entity) {
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

    func publishData(for entityId: EntityID? = nil) async throws {
        var publishEntityId: EntityID
        if let entityId = entityId {
            publishEntityId = entityId
        } else {
            publishEntityId = currPlayerId
        }

        guard let foundEntity = entities.first(where: { $0.id == publishEntityId }) else {
            return
        }
        let componentsToPublish = gameWorld.entityComponentManager.getAllComponents(for: foundEntity)

        try? await manager.uploadEntity(entity: foundEntity, components: componentsToPublish)
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
