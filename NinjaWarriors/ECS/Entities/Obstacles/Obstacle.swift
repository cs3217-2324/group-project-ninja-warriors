//
//  Obstacle.swift
//  NinjaWarriors
//
//  Created by Muhammad Reyaaz on 30/3/24.
//

import Foundation

class Obstacle: Equatable, Entity {
    let id: EntityID
    
    init(id: EntityID) {
        self.id = id
    }

    func getInitializingComponents() -> [Component] {
        // TODO: Remove random
        //let xCoord = Double.random(in: 200...300)
        //let yCoord = Double.random(in: 400...500)

        let xCoord = 249.6940593427741
        let yCoord = 492.5799112615923

        let position = Point(xCoord: xCoord, yCoord: yCoord)

        let shape: Shape = CircleShape(center: position, radius: Constants.defaultSize)
        let mass = 8.0
        let width = 50.0
        let height = 50.0
        let image = "rock"

        let collider = Collider(id: RandomNonce().randomNonceString(), entity: self,
                                colliderShape: shape, isColliding: false, isOutOfBounds: false)

        let rigidbody = Rigidbody(id: RandomNonce().randomNonceString(), entity: self, angularDrag: .zero,
                                  angularVelocity: .zero, mass: mass, rotation: .zero, totalForce: Vector.zero,
                                  inertia: .zero, position: shape.center, velocity: Vector.zero,
                                  attachedCollider: collider)

        let spriteComponent = Sprite(id: RandomNonce().randomNonceString(),
                                     entity: self, image: image, width: width,
                                     height: height, health: 10, maxHealth: 100)

        return [collider, rigidbody, spriteComponent]
    }

    func deepCopy() -> Entity {
        Obstacle(id: id)
    }

    func wrapper() -> EntityWrapper? {
        ObstacleWrapper(id: id)
    }

    static func == (lhs: Obstacle, rhs: Obstacle) -> Bool {
        lhs.id == rhs.id
    }
}
