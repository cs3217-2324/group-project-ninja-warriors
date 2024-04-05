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
            applyEffect(effect)
            changeEffectShape(effect)
        }
    }

    func applyEffect(_ effect: EnvironmentEffect) {
        let entityTransforms = manager.getAllComponents(ofType: Transform.self)
        let entityTransformsWithEffect = entityTransforms.filter { entityTransform in
            effect.effectShouldApplyOn(point: entityTransform.position)
        }
        let affectedEntities = entityTransformsWithEffect.map { entityTransform in
            entityTransform.entity
        }
        let affectedHealthComponents = affectedEntities.compactMap { entity in
            manager.getComponent(ofType: Health.self, for: entity)
        }

        for health in affectedHealthComponents {
            health.health -= 5
            print("reduce health by closing zone: \(health.health) / 100")
        }
    }

    func changeEffectShape(_ effect: EnvironmentEffect) {
        //TODO: don't hardcode this, also direct mutation is abit icky
        guard let effectShape = effect.environmentShape as? CircleShape else {
            return
        }
        effectShape.halfLength -= 1
    }
}
