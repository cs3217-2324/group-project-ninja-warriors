//
//  DamageEffectWrapper.swift
//  NinjaWarriors
//
//  Created by proglab on 15/4/24.
//

import Foundation

struct DamageEffectWrapper: ComponentWrapper {
    var id: ComponentID
    var entity: EntityWrapper
    var sourceId: EntityID
    var initialDamage: Double
    var damagePerTick: Double
    var duration: TimeInterval
    var elapsedTime: TimeInterval = 0

    func toComponent(entity: Entity) -> Component? {
        return DamageEffect(id: id, entity: entity, sourceId: sourceId,
                            initialDamage: initialDamage, damagePerTick: damagePerTick,
                            duration: duration)
    }
}
