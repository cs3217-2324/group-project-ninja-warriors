//
//  AttackStrategy.swift
//  NinjaWarriors
//
//  Created by proglab on 6/4/24.
//

import Foundation

protocol AttackStrategy {
    func canAttack(attacker: Entity, target: Entity, manager: EntityComponentManager) -> Bool
    func applyDamageEffect(to target: Entity, from source: Entity,
                           withDamageEffect damageEffect: DamageEffect, manager: EntityComponentManager)
}
