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
        let healthComponents = manager.getAllComponents(ofType: Health.self)
        for attackComponent in attackComponents where !attackComponent.activated {
            for healthComponent in healthComponents {
                attackComponent.attackIfPossible(health: healthComponent, manager: manager)
                print(healthComponent.health)
            }
            attackComponent.setToActivated()
        }
    }
}
