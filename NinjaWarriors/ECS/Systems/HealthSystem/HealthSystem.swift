//
//  HealthSystem.swift
//  NinjaWarriors
//
//  Created by Muhammad Reyaaz on 30/3/24.
//

import Foundation

class HealthSystem: System {
    var manager: EntityComponentManager

    required init(for manager: EntityComponentManager) {
        self.manager = manager
    }

    func update(after time: TimeInterval) {
        let attackComponents = manager.getAllComponents(ofType: Attack.self)
        let entities = manager.getAllEntities()
        for attackComponent in attackComponents where !attackComponent.activated {
            for entity in entities {
                attackComponent.attackIfPossible(target: entity, manager: manager)
            }
        }
    }
}
