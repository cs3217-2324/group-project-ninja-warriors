//
//  ClientViewModel.swift
//  NinjaWarriors
//
//  Created by Muhammad Reyaaz on 6/4/24.
//

import Foundation
import SwiftUI

final class ClientViewModel: ObservableObject {
    private(set) var manager: EntitiesManager
    // TODO: Might abstract out to another simpler entity component manager
    private(set) var entityComponents: [EntityID: [Component]] = [:]
    private(set) var entities: [Entity] = []
    private(set) var matchId: String
    private(set) var currPlayerId: String
    private var queue = EventQueue(label: "clientEventQueue")

    init(matchId: String, currPlayerId: String) {
        self.matchId = matchId
        self.currPlayerId = currPlayerId
        self.manager = RealTimeManagerAdapter(matchId: matchId)
        self.populate()
        startListening()
    }

    func startListening() {
        print("start listening")
        manager.addEntitiesListener { snapshot in
            //print("snap shot received")
            self.queue.async {
                self.populate()
            }
        }
    }

    func populate() {
        Task {
            do {
                let fetchEntitiesComponents = try await manager.getEntitiesWithComponents(currPlayerId)
                let (fetchEntities, fetchEntityComponents) = fetchEntitiesComponents

                if entities.isEmpty {
                    entities = fetchEntities
                }

                if entityComponents == [:] {
                    entityComponents = fetchEntityComponents
                }

                process(fetchEntities, fetchEntityComponents)
            } catch {
                print("Error fetching client data \(error)")
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

    func process(_ fetchEntities: [Entity], _ fetchComponents: [EntityID: [Component]]) {
        for (entityId, entityIdComponents) in fetchComponents {
            if entityComponents[entityId] == nil {
                entityComponents[entityId] = entityIdComponents
                continue
            } else {
                guard var currEntityIdComponents = entityComponents[entityId] else {
                    continue
                }
                entityIdComponents.forEach { entityIdComponent in
                    var isSameType = false
                    for currEntityIdComponent in currEntityIdComponents {
                        if ComponentType(type(of: entityIdComponent)) == ComponentType(type(of: currEntityIdComponent)) {
                            currEntityIdComponent.updateAttributes(entityIdComponent)
                            isSameType = true
                        }
                    }
                    if !isSameType {
                        guard let currEntity: Entity = getEntity(from: entityId) else {
                            return
                        }
                        currEntityIdComponents.append(entityIdComponent.changeEntity(to: currEntity))
                    }
                }
            }
        }

        func publish() {
            Task {
                for entity in entities {
                    do {
                        try await manager.uploadEntity(entity: entity,
                                                       components: entityComponents[entity.id])
                    } catch {
                        print("Error updating client data \(error)")
                    }
                }
            }
        }

        // Only update values that changed
        func updateViews() {
            objectWillChange.send()
        }

        func entityHasRigidAndSprite(for entity: Entity) -> (image: Image, position: CGPoint)? {
            guard let entityComponents = entityComponents[entity.id] else {
                return nil
            }
            guard let rigidbody = entityComponents.first(where: { $0 is Rigidbody }) as? Rigidbody,
                  let sprite = entityComponents.first(where: { $0 is Sprite }) as? Sprite else {
                return nil
            }
            return (image: Image(sprite.image), position: rigidbody.position.get())
        }

        func setInput(_ vector: CGVector, for entity: Entity) {
            guard let entityIdComponents = entityComponents[entity.id] else {
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
        }
    }
}


extension ClientViewModel {
    func activateSkill(forEntity entity: Entity, skillId: String) {
        let entityId = entity.id
        guard let components = entityComponents[entityId] else {
            return
        }
        for component in components {
            if let component = component as? SkillCaster {
                component.queueSkillActivation(skillId)
            }
        }
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

    func getSkillCooldowns(for entity: Entity) -> Dictionary<SkillID, TimeInterval> {
        let entityId = entity.id
        let skillCaster = gameWorld.entityComponentManager
            .getComponentFromId(ofType: SkillCaster.self, of: entityId)

        if let skillCooldowns = skillCaster?.skillCooldowns {
            print("skillsCds", skillCooldowns)
            return skillCooldowns
        } else {
            return [:]
        }
    }
}
