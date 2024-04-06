//
//  MeleeAttackStrategy.swift
//  NinjaWarriors
//
//  Created by proglab on 6/4/24.
//

import Foundation

class MeleeAttackStrategy: AttackStrategy {
    var radius: CGFloat

    init(radius: CGFloat) {
        self.radius = radius
    }

    func canAttack(attacker: Entity, attackee: Entity, manager: EntityComponentManager) -> Bool {
        guard let attackerCollider = manager.getComponent(ofType: Collider.self, for: attacker),
              let attackeeCollider = manager.getComponent(ofType: Collider.self, for: attackee) else {
            return false
        }

        let attackerPosition = attackerCollider.getPosition()
        let attackeePosition = attackeeCollider.getPosition()

        if attackerPosition.distance(to: attackeePosition) <= radius {
            return true
        }
        return false
    }
}
