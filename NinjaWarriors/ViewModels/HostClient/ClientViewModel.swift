//
//  ClientViewModel.swift
//  NinjaWarriors
//
//  Created by Muhammad Reyaaz on 6/4/24.
//

import Foundation
import SwiftUI

@MainActor
final class ClientViewModel: ObservableObject {
    var manager: EntitiesManager
    var entityComponentManager: EntityComponentManager
    @Published var entities: [Entity] = []
    var matchId: String
    var currPlayerId: String
    var queue = EventQueue(label: "clientEventQueue")
    private var timer: Timer?

    init(matchId: String, currPlayerId: String) {
        self.matchId = matchId
        self.currPlayerId = currPlayerId
        self.manager = RealTimeManagerAdapter(matchId: matchId)
        self.entityComponentManager = EntityComponentManager(for: matchId)
        entityComponentManager.startListening()
        startTimer()
    }

    private func startTimer() {
        // Schedule a timer to fire every 0.1 seconds
        timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { _ in
            for entity in self.entities where self.currPlayerId == "kn2Ap0BtgChusWyyHZtpV42RxmZ2" {
                //self.entityComponentManager.populate()
                print("refresh", self.entityComponentManager.getComponent(ofType: Rigidbody.self, for: entity)?.position.xCoord)
                self.objectWillChange.send()
            }
        }
    }

    func getEntity(from id: EntityID) -> Entity? {
        for entity in entities {
            if entity.id == id {
                return entity
            }
        }
        return nil
    }

    func getCurrPlayer() -> Entity? {
        for entity in entities where entity.id == currPlayerId {
            return entity
        }
        return nil
    }

    func updateEntities() {
        entities = entityComponentManager.getAllEntities()
    }

    func move(_ vector: CGVector) {
        guard let entityIdComponents = entityComponentManager.entityComponentMap[currPlayerId] else {
            return
        }
        for entityIdComponent in entityIdComponents {
            if let entityIdComponent = entityIdComponent as? Rigidbody {
                if entityIdComponent.attachedCollider?.isColliding == true {
                    entityIdComponent.collidingVelocity = Vector(horizontal: vector.dx,
                                                                 vertical: vector.dy)
                } else {
                    entityIdComponent.velocity = Vector(horizontal: vector.dx, vertical: vector.dy)
                }
            }
        }
        Task {
            try await entityComponentManager.publish()
        }
    }

    func render(for entity: Entity) -> (image: Image, position: CGPoint)? {
        let entityComponents = entityComponentManager.getAllComponents(for: entity)

        guard let rigidbody = entityComponents.first(where: { $0 is Rigidbody }) as? Rigidbody,
              let sprite = entityComponents.first(where: { $0 is Sprite }) as? Sprite else {
            return nil
        }
        return (image: Image(sprite.image), position: rigidbody.position.get())
    }
}

extension ClientViewModel {
    func activateSkill(forEntity entity: Entity, skillId: String) {
        let entityId = entity.id
        guard let components = entityComponentManager.entityComponentMap[entityId] else {
            return
        }
        for component in components {
            if let skillCaster = component as? SkillCaster {
                skillCaster.queueSkillActivation(skillId)
            }
        }
    }

    func getSkillIds(for entity: Entity) -> [String] {
        let entityId = entity.id
        guard let components = entityComponentManager.entityComponentMap[entityId] else {
            return []
        }
        for component in components {
            if let skillCaster = component as? SkillCaster {
                let skillCasterIds = skillCaster.skills.keys
                return Array(skillCasterIds)
            }
        }
        return []
    }

    func getSkills(for entity: Entity) -> [Dictionary<SkillID, any Skill>.Element] {
        let entityId = entity.id
        guard let components = entityComponentManager.entityComponentMap[entityId] else {
            return []
        }
        for component in components {
            if let skillCaster = component as? SkillCaster {
                let skills = skillCaster.skills
                return Array(skills)
            }
        }
        return []
    }

    func getSkillCooldowns(for entity: Entity) -> Dictionary<SkillID, TimeInterval> {
        let entityId = entity.id
        guard let components = entityComponentManager.entityComponentMap[entityId] else {
            return [:]
        }
        for component in components {
            if let skillCaster = component as? SkillCaster {
                let skillsCooldown = skillCaster.skillCooldowns
                return skillsCooldown
            }
        }
        return [:]
    }
}
