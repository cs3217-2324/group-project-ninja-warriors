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
    private(set) var matchId: String
    private(set) var currPlayerId: String

    init(matchId: String, currPlayerId: String) {
        self.matchId = matchId
        self.currPlayerId = currPlayerId
        self.gameWorld = GameWorld(for: matchId)
        gameWorld.start()
        gameWorld.updateViewModel = { [unowned self] in
            Task {
                try await self.updateViewModel()
            }
        }
    }

    func updateViewModel() async throws {
        updateEntities()
        updateViews()
        try await gameWorld.entityComponentManager.publish()
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

    func entityHasRigidAndSprite(for entity: Entity) -> (image: Image, position: CGPoint)? {
        let entityComponents = gameWorld.entityComponentManager.getAllComponents(for: entity)

        guard let rigidbody = entityComponents.first(where: { $0 is Collider }) as? Collider,
              let sprite = entityComponents.first(where: { $0 is Sprite }) as? Sprite else {
            return nil
        }
        return (image: Image(sprite.image), position: rigidbody.colliderShape.center.get())
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
            print("skills", skills)
            return Array(skills)
        } else {
            return []
        }
    }
}
