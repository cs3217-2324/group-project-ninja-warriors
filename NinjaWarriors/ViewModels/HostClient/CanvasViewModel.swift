//
//  CanvasViewModel.swift
//  NinjaWarriors
//
//  Created by Muhammad Reyaaz on 15/3/24.
//

// TODO: Rename to HostViewModel once merge. Leave it for now so that merge will not be too messy
import Foundation
import SwiftUI

@MainActor
final class CanvasViewModel: HostClientProtocol {
    var gameWorld: GameWorld
    internal var entities: [Entity] = []
    internal var matchId: String
    internal var currPlayerId: String

    init(matchId: String, currPlayerId: String) {
        self.matchId = matchId
        self.currPlayerId = currPlayerId
        self.gameWorld = GameWorld(for: matchId)
        gameWorld.start()
        gameWorld.updateViewModel = { [unowned self] in
            Task {
                await self.updateViewModel()
            }
        }
    }

    func updateViewModel() async {
        do {
            try await gameWorld.entityComponentManager.publish()
        } catch {
            print("Error publishing updated state: \(error)")
        }
        updateEntities()
        updateViews()
    }

    func updateEntities() {
        entities = gameWorld.entityComponentManager.getAllEntities()
    }

    // Only update values that changed
    func updateViews() {
        objectWillChange.send()
    }

    func getCurrPlayer() -> Entity? {
        for entity in entities where entity.id == currPlayerId {
            return entity
        }
        return nil
    }

    func entityHasRigidAndSprite(for entity: Entity) -> (sprite: Sprite, position: CGPoint)? {
        let entityComponents = gameWorld.entityComponentManager.getAllComponents(for: entity)

        guard let rigidbody = entityComponents.first(where: { $0 is Rigidbody }) as? Rigidbody,
              let sprite = entityComponents.first(where: { $0 is Sprite }) as? Sprite else {
            return nil
        }
        return (sprite: sprite, position: rigidbody.position.get())
    }
    
    func entityHealthComponent(for entity: Entity) -> Health? {
        let entityComponents = gameWorld.entityComponentManager.getAllComponents(for: entity)

        guard let health = entityComponents.first(where: { $0 is Health }) as? Health else {
            return nil
        }
        return health
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
//            print("skills", skills)
            return Array(skills)
        } else {
            return []
        }
    }
    
    func getSkillCooldowns(for entity: Entity) -> Dictionary<SkillID, TimeInterval> {
        let entityId = entity.id
        let skillCaster = gameWorld.entityComponentManager
            .getComponentFromId(ofType: SkillCaster.self, of: entityId)

        if let skillCooldowns = skillCaster?.skillCooldowns {
//            print("skillsCds", skillCooldowns)
            return skillCooldowns
        } else {
            return [:]
        }
    }
}
