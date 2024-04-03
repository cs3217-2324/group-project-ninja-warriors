//
//  CanvasViewModel.swift
//  NinjaWarriors
//
//  Created by Muhammad Reyaaz on 15/3/24.
//

import Foundation
import SwiftUI
import Dispatch

@MainActor
final class CanvasViewModel: ObservableObject {
    var gameWorld: GameWorld
    private(set) var entities: [Entity] = []
    private(set) var manager: EntitiesManager
    private(set) var matchId: String
    private(set) var currPlayerId: String
    let semaphore = DispatchSemaphore(value: 1)

    init(matchId: String, currPlayerId: String) {
        self.matchId = matchId
        self.currPlayerId = currPlayerId
        self.manager = RealTimeManagerAdapter(matchId: matchId)
        self.gameWorld = GameWorld(for: matchId)

        gameWorld.start()
        gameWorld.updateViewModel = { [weak self] in
            guard let self = self else { return }
        //gameWorld.updateViewModel = { [unowned self] in
            Task {
                await self.updateViewModel()
            }
        }

        Task {
            await test()
        }
    }

    func test() async {
        updateEntities()
        do {
            semaphore.wait()
            try await gameWorld.entityComponentManager.publish()
            semaphore.signal()
        } catch {
            print("catch")
        }
    }

    func updateViewModel() async {
        print("update view model")
        // Publish data
        //await publishData()

        // Signal the semaphore to indicate that publishData has finished

        //semaphore.wait()
        //updateEntities()
        //semaphore.signal()

        semaphore.wait()

        do {
            try await gameWorld.entityComponentManager.publish()
        } catch {
            print("catch")
        }

        semaphore.signal()

        // Wait for the semaphore before updating entities
        //await publishData()

        // Update views
        updateViews()

        print("one loop done")
    }

    func updateEntities() {
        entities = gameWorld.entityComponentManager.getAllEntities()
    }

    // Only update positions that changed
    func updateViews() {
        objectWillChange.send()
    }

    func getCurrPlayer() -> Entity? {
        for entity in entities where entity.id == currPlayerId {
            return entity
        }
        return nil
    }

    func publishData(for entityId: EntityID? = nil) async {
        //print("publish data")

        // Inside a function or method
        /*
        Task {
            if let fetchedEntities = try await manager.getAllEntities() {
                entities = fetchedEntities
            } else {
                // Handle the case where getAllEntities() returns nil
                // For example:
                print("Error: Unable to fetch entities")
            }
        }
        */

        var publishEntityId: EntityID
        if let entityId = entityId {
            publishEntityId = entityId
        } else {
            publishEntityId = currPlayerId
        }

        guard let foundEntity = entities.first(where: { $0.id == publishEntityId }) else {
            return
        }
        //print("found entity", foundEntity)
        let componentsToPublish = gameWorld.entityComponentManager.getAllComponents(for: foundEntity)

        do {
            //semaphore.wait()
            try await manager.uploadEntity(entity: foundEntity, components: componentsToPublish)
            //semaphore.signal()
        } catch {
            print("Error occurred: \(error)")
        }
        //entities = gameWorld.entityComponentManager.getAllEntities()
        print("entities check", entities)
    }

    func entityHasRigidAndSprite(for entity: Entity) -> (image: Image, position: CGPoint)? {
        let entityComponents = gameWorld.entityComponentManager.getAllComponents(for: entity)

        guard let rigidbody = entityComponents.first(where: { $0 is Rigidbody }) as? Rigidbody,
              let sprite = entityComponents.first(where: { $0 is Sprite }) as? Sprite else {
            return nil
        }
        return (image: Image(sprite.image), position: rigidbody.position.get())
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
