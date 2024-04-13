//
//  LifespanWrapper.swift
//  NinjaWarriors
//
//  Created by Muhammad Reyaaz on 12/4/24.
//

import Foundation

struct LifespanWrapper: ComponentWrapper {
    var id: ComponentID
    var entity: EntityWrapper
    var lifespan: TimeInterval
    var elapsedTime: TimeInterval

    func toComponent(entity: Entity) -> Component? {
        return Lifespan(id: id, entity: entity, lifespan: lifespan, elapsedTime: elapsedTime)
    }
}
