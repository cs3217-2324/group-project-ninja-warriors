//
//  HadoukenSkill.swift
//  NinjaWarriors
//
//  Created by Joshen on 15/4/24.
//

import Foundation
class HadoukenSkill: EntitySpawnerSkill {
    var id: SkillID
    var cooldownDuration: TimeInterval
    var projectileSpeed: Double = 300

    required init(id: SkillID) {
        self.id = id
        self.cooldownDuration = 0
    }

    convenience init(id: SkillID, cooldownDuration: TimeInterval) {
        self.init(id: id)
        self.cooldownDuration = cooldownDuration
    }

    func activate(from entity: Entity, in manager: EntityComponentManager) {
       _ = spawnEntity(from: entity, in: manager)
    }

    func updateAttributes(_ newHadoukenSkill: HadoukenSkill) {
        self.id = newHadoukenSkill.id
        self.cooldownDuration = newHadoukenSkill.cooldownDuration
    }

    func spawnEntity(from casterEntity: Entity, in manager: EntityComponentManager) -> Entity {
        print("[HadoukenSkill] Activated by \(casterEntity)")

        let hadouken = Hadouken(id: RandomNonce().randomNonceString(), casterEntity: casterEntity)

        guard let playerRigidbody = manager.getComponent(ofType: Rigidbody.self, for: casterEntity) else {
            print("[HadoukenSkill] No Rigidbody found for caster")
            return hadouken
        }

        let direction = Vector(horizontal: cos(playerRigidbody.rotation), vertical: sin(playerRigidbody.rotation))
        let initialPosition = playerRigidbody.position.add(vector: direction.scale(Constants.defaultSize * 1.5))

        let shape: Shape = CircleShape(center: playerRigidbody.position, radius: Constants.defaultSize)

        let collider = Collider(id: RandomNonce().randomNonceString(), entity: hadouken,
                                      colliderShape: shape, collidedEntities: [],
                                      isColliding: false, isOutOfBounds: false)

        let rigidbody = Rigidbody(
            id: RandomNonce().randomNonceString(),
            entity: hadouken,
            angularDrag: 0.0,
            angularVelocity: Vector.zero,
            mass: 1.0,
            rotation: playerRigidbody.rotation,
            totalForce: Vector.zero,
            inertia: 1.0,
            position: initialPosition,
            velocity: direction.scale(projectileSpeed),
            attachedCollider: collider
        )

        let spriteComponent = Sprite(id: RandomNonce().randomNonceString(),
                                     entity: hadouken, image: "hadouken-effect",
                                     width: Constants.slashRadius * 3,
                                     height: Constants.slashRadius * 1)

        let meleeAttackStrategy = MeleeAttackStrategy(casterEntity: casterEntity, radius: Constants.slashRadius)
        let damageEffect = DamageEffect(id: RandomNonce().randomNonceString(), entity: hadouken, sourceId: casterEntity.id, initialDamage: 100, damagePerSecond: 0, duration: 0)  // Instantaneous damage

        let attackComponent = Attack(id: RandomNonce().randomNonceString(), entity: hadouken, attackStrategy: MeleeAttackStrategy(casterEntity: casterEntity, radius: Constants.slashRadius), damageEffectTemplate: damageEffect)

        let lifespanComponent = Lifespan(id: RandomNonce().randomNonceString(), entity: hadouken, lifespan: 1)

        manager.add(entity: hadouken, components: [collider, rigidbody, spriteComponent,
                                                   attackComponent, lifespanComponent], isAdded: false)

        manager.addOwnEntity(hadouken)

        return hadouken
    }

    func wrapper() -> SkillWrapper {
        return SkillWrapper(id: id, type: "HadoukenSkill", cooldownDuration: cooldownDuration)
    }
}