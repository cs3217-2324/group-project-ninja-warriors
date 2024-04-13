//
//  Lifespan.swift
//  NinjaWarriors
//
//  Created by proglab on 6/4/24.
//

import Foundation

class Lifespan: Component {
    let lifespan: TimeInterval
    var elapsedTime: TimeInterval

    init(id: ComponentID, entity: Entity, lifespan: TimeInterval, elapsedTime: TimeInterval = 0) {
        self.lifespan = lifespan
        self.elapsedTime = elapsedTime
        super.init(id: id, entity: entity)
    }

    override func wrapper() -> ComponentWrapper? {
        guard let entityWrapper = entity.wrapper() else {
            return nil
        }
        return LifespanWrapper(id: id, entity: entityWrapper, lifespan: lifespan, elapsedTime: elapsedTime)
    }
}
