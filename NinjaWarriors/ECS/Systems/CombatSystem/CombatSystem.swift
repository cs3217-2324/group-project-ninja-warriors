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

        for damageEffect in damageEffects {
            if damageEffect.elapsedTime == 0 {  // Apply initial damage
                applyDamage(damageEffect.initialDamage, to: damageEffect.entity, from: damageEffect.sourceId)
            }

            damageEffect.elapsedTime += time
            if damageEffect.elapsedTime >= damageEffect.duration {
                toRemove.append(damageEffect)
            } else {
                let damage = damageEffect.damagePerTick * time
                applyDamage(damage, to: damageEffect.entity, from: damageEffect.sourceId)
            }
        }

        // Remove expired DamageEffects
        for effect in toRemove {
            manager.remove(ofComponentType: DamageEffect.self, from: effect.entity)
        }
    }

    private func applyDamage(_ damage: Double, to entity: Entity, from sourceID: EntityID) {
        guard let dodge = manager.getComponent(ofType: Dodge.self, for: entity) else {
            return
        }

        if let health = manager.getComponent(ofType: Health.self, for: entity) {
            health.health -= damage
            recordDamage(damage, to: entity.id, by: sourceID)
        }
    }

    private func recordDamage(_ damage: Double, to targetID: EntityID, by sourceID: EntityID) {
        manager.entityMetricsRecorder.record(DamageDealtMetric.self, forEntityID: sourceID, value: damage)
        manager.entityMetricsRecorder.record(DamageTakenMetric.self, forEntityID: targetID, value: damage)
    }
}
