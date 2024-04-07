//
//  EnvironmentEffectSystem.swift
//  NinjaWarriors
//
//  Created by Jivesh Mohan on 5/4/24.
//

import Foundation

class EnvironmentEffectSystem: System {
    var manager: EntityComponentManager

    required init(for manager: EntityComponentManager) {
        self.manager = manager
    }

    func update(after time: TimeInterval) {
        let effects = manager.getAllComponents(ofType: EnvironmentEffect.self)

        for effect in effects {
            applyEffect(effect, after: time)
            changeEffectShape(effect, after: time)
        }
    }

    func applyEffect(_ effect: EnvironmentEffect, after time: TimeInterval) {
        let rigidBodies = manager.getAllComponents(ofType: Rigidbody.self)
        let rigidBodiesWithEffect = rigidBodies.filter { rigidBody in
            effect.effectShouldApplyOn(point: rigidBody.position)
        }
        let affectedEntities = rigidBodiesWithEffect.map { rigidBody in
            rigidBody.entity
        }
        let affectedHealthComponents = affectedEntities.compactMap { entity in
            manager.getComponent(ofType: Health.self, for: entity)
        }

        for health in affectedHealthComponents {
            let healthChange = Constants.closingZoneDPS * time
            health.health -= healthChange
            // print("reduce health by closing zone: \(healthChange) / 100")
        }
    }

    func changeEffectShape(_ effect: EnvironmentEffect, after time: TimeInterval) {
        guard let effectShape = effect.environmentShape as? CircleShape else {
            return
        }

        let oldRadius = effectShape.halfLength
        guard oldRadius > Constants.closingZoneMinimumSize else {
            return
        }

        let radiusChange = time * Constants.closingZoneRadiusShrinkagePerSecond
        let newRadius = oldRadius - radiusChange
        // print("Shrinking from \(oldRadius) to \(newRadius)")
        let newShape = CircleShape(center: effectShape.center, radius: newRadius)
        effect.updateShape(newShape)
    }
}
