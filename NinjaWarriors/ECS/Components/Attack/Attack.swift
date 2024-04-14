//
//  Attack.swift
//  NinjaWarriors
//
//  Created by proglab on 6/4/24.
//

import Foundation

class Attack: Component {
    var attackStrategy: AttackStrategy
    var damageEffectTemplate: DamageEffect
    var activated: Bool = false

    init(id: ComponentID, entity: Entity, attackStrategy: AttackStrategy, damageEffectTemplate: DamageEffect) {
        self.attackStrategy = attackStrategy
        self.damageEffectTemplate = damageEffectTemplate
        super.init(id: id, entity: entity)
    }

    func attackIfPossible(target: Entity, manager: EntityComponentManager) {
        if attackStrategy.canAttack(attacker: self.entity, target: target, manager: manager) {
            let uniqueDamageEffect = DamageEffect(
                id: RandomNonce().randomNonceString(),
                entity: target,
                sourceId: self.entity.id,
                initialDamage: damageEffectTemplate.initialDamage,
                damagePerSecond: damageEffectTemplate.damagePerSecond,
                duration: damageEffectTemplate.duration
            )
            attackStrategy.applyDamageEffect(to: target, from: self.entity, withDamageEffect: uniqueDamageEffect, manager: manager)
            self.activated = true
        }
    }
}
