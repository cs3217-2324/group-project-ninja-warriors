//
//  DamageEffect.swift
//  NinjaWarriors
//
//  Created by Joshen on 15/4/24.
//

import Foundation

class DamageEffect: Component {
    var sourceId: EntityID
    var initialDamage: Double
    var damagePerTick: Double
    var duration: TimeInterval
    var elapsedTime: TimeInterval = 0

    init(id: ComponentID, entity: Entity, sourceId: EntityID, initialDamage: Double,
         damagePerTick: Double, duration: TimeInterval) {
        self.sourceId = sourceId
        self.initialDamage = initialDamage
        self.damagePerTick = damagePerTick
        self.duration = duration
        super.init(id: id, entity: entity)
    }

    override func changeEntity(to entity: Entity) -> DamageEffect {
        DamageEffect(id: self.id, entity: entity, sourceId: self.sourceId,
                     initialDamage: self.initialDamage, damagePerTick: self.damagePerTick,
                     duration: self.duration)
    }

    override func wrapper() -> ComponentWrapper? {
        guard let entityWrapper = entity.wrapper() else {
            return nil
        }
        return DamageEffectWrapper(id: id, entity: entityWrapper, sourceId: sourceId,
                                   initialDamage: initialDamage, damagePerTick: damagePerTick,
                                   duration: duration)
    }
}
