//
//  SlashAOE.swift
//  NinjaWarriors
//
//  Created by proglab on 23/3/24.
//

import Foundation

class SlashAOE: Entity {
    let id: EntityID
    var shape: Shape

    init(id: EntityID, shape: Shape) {
        self.id = id
        self.shape = shape
    }

    func getInitializingComponents() -> [Component] {
        let collider = Collider(id: RandomNonce().randomNonceString(), entity: self,
                                colliderShape: shape, bounciness: 0, density: 0,
                                restitution: 0, isColliding: false,
                                offset: Vector(horizontal: 0, vertical: 0))
        return [collider]
    }

    func wrapper() -> EntityWrapper? {
        return EntityWrapper(id: id, shape: shape.toShapeWrapper())
    }
}
