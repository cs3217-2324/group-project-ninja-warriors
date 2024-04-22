//
//  RespawnSystem.swift
//  NinjaWarriors
//
//  Created by proglab on 21/4/24.
//

import Foundation

class RespawnSystem: System {
    var manager: EntityComponentManager
    var respawnList: [(Entity, Point?, TimeInterval)] = []

    required init(for manager: EntityComponentManager) {
        self.manager = manager
    }

    func update(after time: TimeInterval) {
        let destroyTags = manager.getAllComponents(ofType: DestroyTag.self)
        for destroyTag in destroyTags {
            guard let respawnable = manager.getComponent(ofType: Respawnable.self, for: destroyTag.entity) else {
                continue
            }

            let rigidbody = manager.getComponent(ofType: Rigidbody.self, for: destroyTag.entity)
            let position = rigidbody?.position

            respawnList.append((respawnable.entity, position, respawnable.respawnTime))
        }

        var updatedList: [(Entity, Point?, TimeInterval)] = []
        for (entity, position, timeLeft) in respawnList {
            let newTimeLeft = timeLeft - time
            if newTimeLeft <= 0 {
                let entityWithNewID = entity.deepCopyWithNewID()
                var components = entityWithNewID.getInitializingComponents()

                if let position {
                    for (index, component) in components.enumerated() {
                        if let rigidbody = component as? Rigidbody {
                            rigidbody.position = position
                            rigidbody.attachedCollider?.colliderShape.center = position
                            components[index] = rigidbody
                        }
                    }
                }

                manager.addOwnEntity(entityWithNewID)
                manager.add(entity: entityWithNewID, components: components, isAdded: false)
            } else {
                updatedList.append((entity, position, newTimeLeft))
            }
        }

        respawnList = updatedList
    }
}
