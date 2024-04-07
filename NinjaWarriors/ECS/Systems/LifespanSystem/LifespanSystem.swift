//
//  LifespanSystem.swift
//  NinjaWarriors
//
//  Created by proglab on 6/4/24.
//

import Foundation

class LifespanSystem: System {
    var manager: EntityComponentManager

    required init(for manager: EntityComponentManager) {
        self.manager = manager
    }

    func update(after time: TimeInterval) {
        let lifespanComponents = manager.getAllComponents(ofType: Lifespan.self)
        for lifespanComponent in lifespanComponents {
            lifespanComponent.elapsedTime += time
            if lifespanComponent.elapsedTime > lifespanComponent.lifespan {
                manager.remove(entity: lifespanComponent.entity, isRemoved: false)
            }
        }
    }
}
