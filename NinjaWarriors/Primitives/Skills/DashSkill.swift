//
//  DashSkill.swift
//  NinjaWarriors
//
//  Created by Joshen Lim on 19/3/24.
//

import Foundation

class DashSkill: MovementSkill {
    var id: SkillID
    var cooldownDuration: TimeInterval

    required init(id: SkillID) {
        self.id = id
        self.cooldownDuration = 0
    }

    convenience init(id: SkillID, cooldownDuration: TimeInterval) {
        self.init(id: id)
        self.cooldownDuration = cooldownDuration
    }

    func activate(from entity: Entity, in manager: EntityComponentManager) {
        performMovement(on: entity, in: manager)
    }

    func updateAttributes(_ newDashSkill: DashSkill) {
        self.id = newDashSkill.id
        self.cooldownDuration = newDashSkill.cooldownDuration
    }

    func performMovement(on target: Entity, in manager: EntityComponentManager) {
        print("[DashSkill] Activated on \(target)")
        guard let playerRigidbody = manager.getComponent(ofType: Rigidbody.self, for: target) else {
            print("[DashSkill] No player rigidbody found")
            return
        }

        let dashDistance = 200.0
        let rotationRadians = playerRigidbody.rotation * .pi / 180

        // Calculate movement vector components based on the rotation
        let dx = cos(rotationRadians) * dashDistance
        let dy = sin(rotationRadians) * dashDistance

        // Create the movement vector
        let movementVector = Vector(horizontal: dx, vertical: dy)

        // Apply the movement
        playerRigidbody.movePosition(by: movementVector)
    }

    func wrapper() -> SkillWrapper {
        return SkillWrapper(id: id, type: "DashSkill", cooldownDuration: cooldownDuration)
    }
}
