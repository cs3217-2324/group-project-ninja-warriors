//
//  DestroySystem.swift
//  NinjaWarriors
//
//  Created by proglab on 5/4/24.
//

import Foundation

class DestroySystem: System {
    var manager: EntityComponentManager
    
    required init(for manager: EntityComponentManager) {
        self.manager = manager
    }
    
    func update(after time: TimeInterval) {
        let healthComponents = manager.getAllComponents(ofType: Health.self)
        for healthComponent in healthComponents where healthComponent.health <= 0 {
            manager.remove(entity: healthComponent.entity, isRemoved: false)
        }
    }
}
