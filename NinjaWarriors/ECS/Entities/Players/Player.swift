//
//  Player.swift
//  NinjaWarriors
//
//  Created by Muhammad Reyaaz on 15/3/24.
//

import Foundation

class Player: Equatable, Entity {
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
        []
    }

    func deepCopy() -> Entity {
        Player(id: id)
    }

    func wrapper() -> EntityWrapper? {
        return PlayerWrapper(id: id)
    }

    static func == (lhs: Player, rhs: Player) -> Bool {
        lhs.id == rhs.id
    }
}

extension Player {
    func getMockComponents() -> [Component] {
        let shape = Shape(center: initializePosition, halfLength: Constants.defaultSize)

        let playerCollider = Collider(id: RandomNonce().randomNonceString(), entity: self,
                                      colliderShape: shape, collidedEntities: [],
                                      isColliding: false, isOutOfBounds: false)

        let playerRigidbody = Rigidbody(id: RandomNonce().randomNonceString(), entity: self,
                                        angularDrag: 0.0, angularVelocity: Vector.zero, mass: 8.0,
                                        rotation: 0.0, totalForce: Vector.zero, inertia: 0.0,
                                        position: shape.center, velocity: Vector.zero,
                                        attachedCollider: playerCollider)

        let skillCaster = SkillCaster(id: RandomNonce().randomNonceString(),
                                      entity: self, skills: [SlashAOESkill(id: "slash", cooldownDuration: 8.0),
                                                             DashSkill(id: "dash", cooldownDuration: 8.0),
                                                             DodgeSkill(id: "dodge", cooldownDuration: 8.0),
                                                            RefreshCooldownsSkill(id: "refresh", cooldownDuration: 30.0)])

        let spriteComponent = Sprite(id: RandomNonce().randomNonceString(), entity: self,
                                     image: "player-icon", width: 50.0, height: 50.0, health: 10,
                                     maxHealth: 100)

        let health = Health(id: RandomNonce().randomNonceString(), entity: self,
                                entityInflictDamageMap: [:], health: 100, maxHealth: 100)

        let score = Score(id: RandomNonce().randomNonceString(), entity: self,
                          score: 0, entityGainScoreMap: [:])

        let dodge = Dodge(id: RandomNonce().randomNonceString(), entity: self, isEnabled: true, invulnerabilityDuration: 2.0, elapsedTimeSinceEnabled: 0.0)

        return [playerRigidbody, playerCollider, skillCaster, spriteComponent, health, score, dodge]
    }
}
