//
//  Player.swift
//  NinjaWarriors
//
//  Created by Muhammad Reyaaz on 15/3/24.
//

import Foundation

class Player: Equatable, Entity {
    let id: EntityID

    init(id: EntityID) {
        self.id = id
    }

    // TODO: remove hardcode after testing
    func getInitializingComponents() -> [Component] {
        var shape: Shape
        if id == "opponent" {
            shape = Shape(center: Constants.playerOnePosition, halfLength: Constants.defaultSize)
        } else {
            shape = Shape(center: Constants.playerTwoPosition, halfLength: Constants.defaultSize)
        }

        // Create the default Collider component for the player
        let playerCollider = Collider(id: RandomNonce().randomNonceString(), entity: self, colliderShape: shape)
        let skillCaster = SkillCaster(id: RandomNonce().randomNonceString(),
                                      entity: self, skills: [SlashAOESkill(id: "slash", cooldownDuration: 8.0),
                                                             DashSkill(id: "dash", cooldownDuration: 8.0),
                                                             DodgeSkill(id: "dodge", cooldownDuration: 8.0),
                                                            RefreshCooldownsSkill(id: "refresh")])
        let playerRigidbody = Rigidbody(id: RandomNonce().randomNonceString(), entity: self,
                                        angularDrag: 0.0, angularVelocity: 0.0, mass: 8.0,
                                        rotation: 0.0, totalForce: Vector.zero, inertia: 0.0,
                                        position: shape.center, velocity: Vector(horizontal: 0.0, vertical: 0.0),
                                        attachedColliders: [playerCollider])

        let spriteComponent = Sprite(id: RandomNonce().randomNonceString(), entity: self, image: "player-copy", width: 50.0, height: 50.0, health: 10, maxHealth: 100)


        return [playerRigidbody, playerCollider, skillCaster, spriteComponent]
    }

    func wrapper() -> EntityWrapper? {
        return PlayerWrapper(id: id)
    }

    static func == (lhs: Player, rhs: Player) -> Bool {
        lhs.id == rhs.id
    }
}
