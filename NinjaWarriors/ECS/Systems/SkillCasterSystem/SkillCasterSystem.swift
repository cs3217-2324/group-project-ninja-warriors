//
//  SkillCasterSystem.swift
//  NinjaWarriors
//
//  Created by Joshen Lim on 21/3/24.
//

import Foundation

// The system responsible for handling skill casting logic
class SkillCasterSystem: System {
    var manager: EntityComponentManager?

    required init(for manager: EntityComponentManager) {
        return
    }

    func update(after time: TimeInterval) {
        return
    }

    // This system would be updated every frame or tick
//    func update(entities: [Entity], deltaTime: TimeInterval) {
//        for entity in entities {
//            // Ensure the entity has a SkillCaster component
//            guard let skillCaster = entity.getComponent(ofType: SkillCaster.self) else { continue }
//
//            // Update cooldowns and check for skill activation
//            for (_, skill) in skillCaster.skills {
//                updateCooldown(for: skill, deltaTime: deltaTime)
//
//                // Check conditions to activate the skill (input, AI, etc.)
//                if shouldActivate(skill: skill) {
//                    activate(skill: skill, from: entity)
//                }
//            }
//        }
//    }

//    private func updateCooldown(for skill: Skill, deltaTime: TimeInterval) {
//        if skill.isOnCooldown {
//            skill.cooldown -= deltaTime
//            if skill.cooldown <= 0 {
//                skill.cooldown = 0
//                skill.isOnCooldown = false
//            }
//        }
//    }

    private func shouldActivate(skill: Skill) -> Bool {
        // Implement logic to determine if a skill should be activated
        // This could be a user input or an AI decision
        // ...
        return true
    }

    private func activate(skill: Skill, from entity: Entity) {
        // Prevent activation if the skill is on cooldown
        if skill.isOnCooldown { return }

        skill.activate()

        // Handle skill-specific activation
        if let movementSkill = skill as? MovementSkill {
            movementSkill.performMovement(on: entity)
        }
        // Handle other skill types similarly...
    }
}
