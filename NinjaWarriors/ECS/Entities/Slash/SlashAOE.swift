//
//  SlashAOE.swift
//  NinjaWarriors
//
//  Created by proglab on 23/3/24.
//

import Foundation

class SlashAOE: Entity {
    let id: EntityID
    var casterEntity: Entity
    var shape: Shape

    init(id: EntityID, shape: Shape, casterEntity: Entity) {
        self.id = id
        self.shape = shape
        self.casterEntity = casterEntity
    }

    func getInitializingComponents() -> [Component] {
        let collider = Collider(id: RandomNonce().randomNonceString(), entity: self,
                                colliderShape: shape)
        return [collider]
    }

    func wrapper() -> EntityWrapper? {
        return EntityWrapper(id: id)
    }
}
