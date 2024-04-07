//
//  AttackStrategy.swift
//  NinjaWarriors
//
//  Created by proglab on 6/4/24.
//

import Foundation

protocol AttackStrategy {
    func canAttack(attacker: Entity, attackee: Entity, manager: EntityComponentManager) -> Bool
    func attack(health: Health, damage: Double)
}

extension AttackStrategy {
    func attack(health: Health, damage: Double) {
        health.health -= damage
    }
}
