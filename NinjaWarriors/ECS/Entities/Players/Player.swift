//
//  Player.swift
//  NinjaWarriors
//
//  Created by Muhammad Reyaaz on 15/3/24.
//

import Foundation

class Player: Equatable, Entity {
    let id: EntityID
    var shape: Shape

    init(id: EntityID, shape: Shape) {
        self.id = id
        self.shape = shape
    }

    func getInitializingComponents() -> [Component] {
        let playerRigidbody = Rigidbody(id: RandomNonce().randomNonceString(), entity: self,
                                        angularDrag: 0.0, angularVelocity: 0.0, mass: 8.0,
                                        rotation: 0.0, totalForce: Vector.zero, gravityScale: 1.0,
                                        inertia: 0.0, collisionDetectionMode: true, position: shape.center,
                                        velocity: Vector(horizontal: 5.0, vertical: 5.0),
                                        attachedColliders: [])

        // Create the default Collider component for the player
        let playerCollider = Collider(id: RandomNonce().randomNonceString(), entity: self,
                                      colliderShape: shape, bounciness: 0.0, density: 0.0, restitution: 0.0,
                                      isColliding: false, offset: Vector(horizontal: 0.0, vertical: 0.0))
        // TODO: remove hardcode
        let skillCaster = SkillCaster(id: RandomNonce().randomNonceString(),
                                      entity: self, skills: [SlashAOESkill(id: "skill1", cooldownDuration: 8.0),
                                                             SlashAOESkill(id: "skill2", cooldownDuration: 8.0),
                                                             SlashAOESkill(id: "skill3", cooldownDuration: 8.0)])
        // TODO: edit sprite component with player sprite
        let spriteComponent = SpriteComponent(id: RandomNonce().randomNonceString(), entity: self)
        return [playerRigidbody, playerCollider, skillCaster, spriteComponent]
    }

    // TODO: Must remove this and make change based on system instead
    /// *
    func getPosition() -> CGPoint {
        shape.getCenter()
    }

    func changePosition(to center: Point) {
        shape.center = center
    }
    // */

    func wrapper() -> EntityWrapper? {
        return PlayerWrapper(id: id, shape: shape.toShapeWrapper())
    }

    static func == (lhs: Player, rhs: Player) -> Bool {
        lhs.id == rhs.id
    }
}
