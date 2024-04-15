//
//  CombatSystem.swift
//  NinjaWarriors
//
//  Created by proglab on 15/4/24.
//

import Foundation

class CombatSystem: System {
    var manager: EntityComponentManager

    required init(for manager: EntityComponentManager) {
        self.manager = manager
    }

    func update(after time: TimeInterval) {
        var toRemove: [DamageEffect] = []
        let damageEffects = manager.getAllComponents(ofType: DamageEffect.self)

        let testing = manager.entityComponentMap

        for damageEffect in damageEffects {
            let test = manager.getAllComponents(ofType: Rigidbody.self)
            print("damage effects", damageEffects, test)
            print("curr damage effect entity", damageEffect.entity)
            // print("damage effect entity unowned", damageEffect.entity)
            if damageEffect.elapsedTime == 0 {  // Apply initial damage
                applyDamage(damageEffect.initialDamage, to: damageEffect.entity)
            }

            damageEffect.elapsedTime += time
            print("damage effect elapsed time", damageEffect.elapsedTime)
            if damageEffect.elapsedTime >= damageEffect.duration {
                print("elapsed time exceeded")
                toRemove.append(damageEffect)
            } else {
                let damage = damageEffect.damagePerTick * time
                applyDamage(damage, to: damageEffect.entity)
            }
        }

        // Remove expired DamageEffects
        for effect in toRemove {
            manager.remove(ofComponentType: DamageEffect.self, from: effect.entity, isRemoved: false)
        }
    }

    private func applyDamage(_ damage: Double, to entity: Entity) {
        /*
        guard manager.getComponent(ofType: Dodge.self, for: entity) == nil else {
            return
        }
        */

        if let health = manager.getComponent(ofType: Health.self, for: entity) {
            print("deduct health")
            health.health -= damage
            manager.componentsQueue.addComponent(health)
        }
    }
}
