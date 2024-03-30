//
//  Obstacle.swift
//  NinjaWarriors
//
//  Created by Muhammad Reyaaz on 30/3/24.
//

import Foundation

class Obstacle: Equatable, Entity {
    let id: EntityID
    let shape: Shape
    let position: Point
    let mass: Double
    let width: Double
    let height: Double
    let image: String

    init(id: EntityID, shape: Shape, position: Point, mass: Double,
         width: Double, height: Double, image: String) {
        self.id = id
        self.shape = shape
        self.position = position
        self.mass = mass
        self.width = width
        self.height = height
        self.image = image
    }

    func getInitializingComponents() -> [Component] {
        let obstaclePosition = position
        let shape = shape

        //var shape: Shape = CircleShape(center: obstaclePosition, radius: Constants.defaultSize)

        let collider = Collider(id: RandomNonce().randomNonceString(), entity: self, colliderShape: shape)

        let rigidbody = Rigidbody(id: RandomNonce().randomNonceString(), entity: self, angularDrag: .zero,
                                  angularVelocity: .zero, mass: mass, rotation: .zero, totalForce: Vector.zero,
                                  inertia: .zero, position: shape.center, velocity: Vector.zero,
                                  attachedCollider: collider)

        // TODO: TBC on health in sprite component
        let spriteComponent = Sprite(id: RandomNonce().randomNonceString(),
                                     entity: self, image: image, width: width,
                                     height: height, health: 10, maxHealth: 100)

        return [collider, rigidbody, spriteComponent]
    }

    func deepCopy() -> Entity {
        Obstacle(id: id, shape: shape, position: position, mass: mass,
                 width: width, height: height, image: image)
    }

    func wrapper() -> EntityWrapper? {
        return RockWrapper(id: id)
    }

    static func == (lhs: Obstacle, rhs: Obstacle) -> Bool {
        lhs.id == rhs.id
    }
}
