//
//  MeleeAttackStrategy.swift
//  NinjaWarriors
//
//  Created by proglab on 6/4/24.
//

import Foundation

class MeleeAttackStrategy: AttackStrategy {
    var casterEntity: Entity
    var radius: CGFloat

    init(casterEntity: Entity, radius: CGFloat) {
        self.casterEntity = casterEntity
        self.radius = radius
    }

    func canAttack(attacker: Entity, target: Entity, manager: EntityComponentManager) -> Bool {
        guard casterEntity.id != target.id, target as? Player != nil else {
            return false
        }

        guard let attackerPosition = manager.getComponent(ofType: Rigidbody.self, for: attacker)?.position,
              let targetPosition = manager.getComponent(ofType: Rigidbody.self, for: target)?.position else {
            return false
        }
        return attackerPosition.distance(to: targetPosition) <= radius
    }

    func applyDamageEffect(to target: Entity, from source: Entity, withDamageEffect damageEffect: DamageEffect, manager: EntityComponentManager) {

        print("slashing", damageEffect.entity)
        // manager.componentsQueue.addComponent(damageEffect)

        manager.add(entity: target, components: [damageEffect]/*, isAdded: false*/)
    }
}
