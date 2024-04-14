//
//  Hadouken.swift
//  NinjaWarriors
//
//  Created by Joshen on 15/4/24.
//

import Foundation

class Hadouken: Entity {
    let id: EntityID
    var casterEntity: Entity

    init(id: EntityID, casterEntity: Entity) {
        self.id = id
        self.casterEntity = casterEntity
    }

    func getInitializingComponents() -> [Component] {
        return []
    }

    func deepCopy() -> Entity {
        Hadouken(id: id, casterEntity: casterEntity.deepCopy())
    }

    func wrapper() -> EntityWrapper? {
        guard let casterEntityWrapper = casterEntity.wrapper() else {
            return nil
        }
        return HadoukenWrapper(id: id, casterEntity: casterEntityWrapper)
    }
}
