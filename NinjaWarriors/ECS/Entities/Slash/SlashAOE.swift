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

    init(id: EntityID, casterEntity: Entity) {
        self.id = id
        self.casterEntity = casterEntity
    }

    func getInitializingComponents() -> [Component] {
        let shape = Shape(center: Constants.playerTwoPosition, halfLength: Constants.defaultSize)
        
        let collider = Collider(id: RandomNonce().randomNonceString(), entity: self, colliderShape: shape, isColliding: false, isOutOfBounds: false)
<<<<<<< HEAD
=======
        
>>>>>>> reyaaz/host
        let rigidbody = Rigidbody(id: RandomNonce().randomNonceString(), entity: self,
                                  angularDrag: 0.0, angularVelocity: 0.0, mass: 8.0,
                                  rotation: 0.0, totalForce: Vector.zero, inertia: 0.0,
                                  position: shape.center, velocity: Vector.zero,
                                  attachedCollider: collider)
<<<<<<< HEAD

        let spriteComponent = Sprite(id: RandomNonce().randomNonceString(),
                                     entity: self, image: "rock", width: 100,
                                     height: 100, health: 10, maxHealth: 100)

        return [collider, rigidbody, spriteComponent]
        return [collider]
=======
        
        let spriteComponent = Sprite(id: RandomNonce().randomNonceString(),
                                     entity: self, image: "rock", width: 100,
                                     height: 100, health: 10, maxHealth: 100)
        
        return [collider, rigidbody, spriteComponent]
>>>>>>> reyaaz/host
    }

    func deepCopy() -> Entity {
        SlashAOE(id: id, casterEntity: casterEntity.deepCopy())
    }

    func wrapper() -> EntityWrapper? {
        guard let casterEntityWrapper = casterEntity.wrapper() else {
            return nil
        }
        return SlashAOEWrapper(id: id, casterEntity: casterEntityWrapper)
    }
}
