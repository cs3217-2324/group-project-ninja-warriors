//
//  Gem.swift
//  NinjaWarriors
//
//  Created by Muhammad Reyaaz on 10/4/24.
//

import Foundation

class Gem: Equatable, Entity {
    let id: EntityID
    var initializePosition: Point = Point(xCoord: 400, yCoord: 400)

    init(id: EntityID) {
        self.id = id
    }

    convenience init(id: EntityID, position: Point) {
        self.init(id: id)
        self.initializePosition = position
    }

    func getInitializingComponents() -> [Component] {
        let position = initializePosition

        let shape: Shape = CircleShape(center: position, radius: Constants.defaultSize)
        let mass = 8.0
        let width = 50.0
        let height = 50.0
        let image = "gem"

        let collider = Collider(id: RandomNonce().randomNonceString(), entity: self,
                                colliderShape: shape, isColliding: false, isOutOfBounds: false)

        let rigidbody = Rigidbody(id: RandomNonce().randomNonceString(), entity: self, angularDrag: .zero,
                                  angularVelocity: .zero, mass: mass, rotation: .zero, totalForce: Vector.zero,
                                  inertia: .zero, position: shape.center, velocity: Vector.zero,
                                  attachedCollider: collider)

        let spriteComponent = Sprite(id: RandomNonce().randomNonceString(), entity: self,
                                     image: image, width: width, height: height)

        let health = Health(id: RandomNonce().randomNonceString(), entity: self,
                            entityInflictDamageMap: [:], health: 10, maxHealth: 10)

        let invisible = Invisible(id: RandomNonce().randomNonceString(), entity: self)

        let collectable = Collectable(id: RandomNonce().randomNonceString(), entity: self, entityType: "Gem")

        return [collider, rigidbody, spriteComponent, health, invisible, collectable]
    }

    func deepCopy() -> Entity {
        Gem(id: id)
    }

    func wrapper() -> EntityWrapper? {
        GemWrapper(id: id)
    }

    static func == (lhs: Gem, rhs: Gem) -> Bool {
        lhs.id == rhs.id
    }
}
