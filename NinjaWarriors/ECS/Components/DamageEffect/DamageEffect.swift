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
    var damagePerSecond: Double
    var duration: TimeInterval
    var elapsedTime: TimeInterval = 0

    init(id: ComponentID, entity: Entity, sourceId: EntityID, initialDamage: Double, damagePerSecond: Double, duration: TimeInterval) {
        self.sourceId = sourceId
        self.initialDamage = initialDamage
        self.damagePerSecond = damagePerSecond
        self.duration = duration
        super.init(id: id, entity: entity)
    }

    override func wrapper() -> ComponentWrapper? {
        guard let entityWrapper = entity.wrapper() else {
            return nil
        }
        return DamageEffectWrapper(id: id, entity: entityWrapper, sourceId: sourceId, initialDamage: initialDamage, damagePerSecond: damagePerSecond, duration: duration)
    }
}
