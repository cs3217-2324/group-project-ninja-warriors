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

    func canAttack(attacker: Entity, attackee: Entity, manager: EntityComponentManager) -> Bool {
        guard casterEntity.id != attackee.id else {
            return false
        }

        if let attackeeDodge = manager.getComponent(ofType: Dodge.self, for: attackee), attackeeDodge.isEnabled {
            return false
        }

        guard let attackerRigidbody = manager.getComponent(ofType: Rigidbody.self, for: attacker),
              let attackeeRigidbody = manager.getComponent(ofType: Rigidbody.self, for: attackee) else {
            return false
        }

        let attackerPosition = attackerRigidbody.position
        let attackeePosition = attackeeRigidbody.position

        if attackerPosition.distance(to: attackeePosition) <= radius {
            return true
        }
        return false
    }
}
