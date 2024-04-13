//
//  Attack.swift
//  NinjaWarriors
//
//  Created by proglab on 6/4/24.
//

import Foundation

class Attack: Component {
    var attackStrategy: AttackStrategy
    var damage: Double
    var activated: Bool

    init(id: ComponentID, entity: Entity, attackStrategy: AttackStrategy, damage: Double, activated: Bool = false) {
        self.attackStrategy = attackStrategy
        self.damage = damage
        self.activated = activated
        super.init(id: id, entity: entity)
    }

    func attackIfPossible(health: Health, manager: EntityComponentManager) {
        let attacker = self.entity
        let attackee = health.entity
        if attackStrategy.canAttack(attacker: attacker, attackee: attackee, manager: manager) {
            attackStrategy.attack(health: health, damage: self.damage)
            /// *
            Task {
                print("attacking")
                try await manager.manager.uploadEntity(entity: attackee, components: [health])
            }
            // */
        }
    }

    func setToActivated() {
        self.activated = true
    }
}
