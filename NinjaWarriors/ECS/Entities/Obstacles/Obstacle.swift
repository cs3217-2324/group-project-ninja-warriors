//
//  Obstacle.swift
//  NinjaWarriors
//
//  Created by Muhammad Reyaaz on 30/3/24.
//

import Foundation

class Obstacle: Equatable, Entity {
    let id: EntityID
    /*
    let shape: Shape
    let position: Point
    let mass: Double
    let width: Double
    let height: Double
    let image: String
    */

    /*
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
    */

    init(id: EntityID) {
        self.id = id
    }

    func getInitializingComponents() -> [Component] {
        // TODO: Remove random
        let xCoord = Double.random(in: 200...300)
        let yCoord = Double.random(in: 400...500)

        let position = Point(xCoord: xCoord, yCoord: yCoord)

        let shape: Shape = CircleShape(center: position, radius: Constants.defaultSize)
        let mass = 8.0
        let width = 50.0
        let height = 50.0
        let image = "rock"

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

    /*
    func deepCopy() -> Entity {
        Obstacle(id: id, shape: shape, position: position, mass: mass,
                 width: width, height: height, image: image)
    }

    func wrapper() -> EntityWrapper? {
        return ObstacleWrapper(id: id, shape: shape.wrapper(), position: position.wrapper(),
                               mass: mass, width: width, height: height, image: image)
    }
    */

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
