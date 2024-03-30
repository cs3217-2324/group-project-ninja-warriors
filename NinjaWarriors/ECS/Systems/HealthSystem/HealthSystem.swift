//
//  HealthSystem.swift
//  NinjaWarriors
//
//  Created by Muhammad Reyaaz on 30/3/24.
//

import Foundation

class HealthSystem: System {
    var manager: EntityComponentManager

    required init(for manager: EntityComponentManager) {
        self.manager = manager
    }

    func update(after time: TimeInterval) {
        let colliderHealthMap = createColliderHealthMap()

        updateHealth(for: colliderHealthMap)
    }

    func createColliderHealthMap() -> [Collider: Health] {
        var colliderHealthMap: [Collider: Health] = [:]

        let colliders = manager.getAllComponents(ofType: Collider.self)
        let healthComponents = manager.getAllComponents(ofType: Health.self)

        for collider in colliders {
            for healthComponent in healthComponents {
                if collider.entity.id == healthComponent.entity.id {
                    colliderHealthMap[collider] = healthComponent
                }
            }
        }
        return colliderHealthMap
    }

    func updateHealth(for colliderHealthMap: [Collider: Health]) {
        for (collider, health) in colliderHealthMap {
            // Assuming 1-1 mapping for now, as it will be refactored accordingly
            guard let collidedEntityID = collider.collidedEntities.first else {
                continue
            }

            updateHealthForCollision(collider: collider, health: health, collidedEntityID: collidedEntityID)
            removeNonCollidingEntities(from: health, collidedEntityID: collidedEntityID)
        }
    }

    // TODO: Remove hardcoded health deduction and take from skills
    func updateHealthForCollision(collider: Collider, health: Health, collidedEntityID: EntityID) {
        // Entity previously collided but then moved away, so reduce health
        if let damagedStatus = health.entityInflictDamageMap[collidedEntityID], !damagedStatus {
            health.entityInflictDamageMap[collidedEntityID] = true
            health.health -= 10
            print("reduce health: \(health.health) / 100")
        // This is the first collision with this entity, so reduce health
        } else if health.entityInflictDamageMap[collidedEntityID] == nil {
            health.entityInflictDamageMap[collidedEntityID] = true
            health.health -= 10
            print("reduce health: \(health.health) / 100")
        }
    }

    // Remove non-colliding entities from the health map
    func removeNonCollidingEntities(from health: Health, collidedEntityID: EntityID) {
        health.entityInflictDamageMap.forEach { (entityID, _) in
            if entityID != collidedEntityID {
                health.entityInflictDamageMap[entityID] = nil
            }
        }
    }
}
