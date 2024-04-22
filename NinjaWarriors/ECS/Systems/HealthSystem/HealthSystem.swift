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
        let healthComponents = manager.getAllComponents(ofType: Health.self)
        for healthComponent in healthComponents where healthComponent.health <= 0 {
            manager.add(entity: healthComponent.entity, components: [DestroyTag(id: RandomNonce().randomNonceString(), entity: healthComponent.entity)])
        }
    }
}
