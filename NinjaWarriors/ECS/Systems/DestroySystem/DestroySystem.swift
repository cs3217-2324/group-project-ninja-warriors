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
        let destroyTags = manager.getAllComponents(ofType: DestroyTag.self)
        for destroyTag in destroyTags {
            manager.remove(entity: destroyTag.entity, isRemoved: false)
        }
    }
}
