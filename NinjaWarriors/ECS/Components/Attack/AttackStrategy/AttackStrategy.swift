//
//  AttackStrategy.swift
//  NinjaWarriors
//
//  Created by proglab on 6/4/24.
//

import Foundation

protocol AttackStrategy {
    func canAttack(attacker: Entity, attackee: Entity, manager: EntityComponentManager) -> Bool
    func attack(health: Health, damage: Int)
}

extension AttackStrategy {
    func attack(health: Health, damage: Int) {
        health.health -= damage
    }
}
