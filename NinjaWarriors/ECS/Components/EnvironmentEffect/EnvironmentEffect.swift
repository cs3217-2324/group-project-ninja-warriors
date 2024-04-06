//
//  EnvironmentEffect.swift
//  NinjaWarriors
//
//  Created by Jivesh Mohan on 5/4/24.
//

import Foundation

class EnvironmentEffect: Component {
    var environmentShape: Shape
    var effectIsActiveInsideShape: Bool

    init(id: ComponentID, entity: Entity, environmentShape: Shape, effectIsActiveInsideShape: Bool) {
        self.environmentShape = environmentShape
        self.effectIsActiveInsideShape = effectIsActiveInsideShape

        super.init(id: id, entity: entity)
    }

    func effectShouldApplyOn(point: Point) -> Bool {
        if effectIsActiveInsideShape {
            return environmentShape.contains(point: point)
        } else {
            return !environmentShape.contains(point: point)
        }
    }

    override func updateAttributes(_ newEnvironmentEffect: Component) {
        guard let newEnvironmentEffect = newEnvironmentEffect as? EnvironmentEffect else {
            return
        }
        self.environmentShape.updateAttributes(newEnvironmentEffect.environmentShape)
        self.effectIsActiveInsideShape = newEnvironmentEffect.effectIsActiveInsideShape
    }

    override func wrapper() -> ComponentWrapper? {
        guard let entityWrapper = entity.wrapper() else {
            return nil
        }

        return EnvironmentEffectWrapper(id: id, entity: entityWrapper, environmentShape: environmentShape, effectIsActiveInsideShape: effectIsActiveInsideShape)
    }
}
