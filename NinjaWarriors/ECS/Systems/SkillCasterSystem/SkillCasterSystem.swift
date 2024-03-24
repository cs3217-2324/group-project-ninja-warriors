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
        self.manager = manager
    }

    func update(after time: TimeInterval) {
        guard let manager = manager else { return }

        let skillCasters = manager.getAllComponents(ofType: SkillCaster.self)
        for skillCaster in skillCasters {
            while !skillCaster.activationQueue.isEmpty {
                let skillId = skillCaster.activationQueue.removeFirst()
                guard let skill = skillCaster.skills[skillId], !skill.isOnCooldown() else { continue }

                skill.activate(from: skillCaster.entity, in: manager)

            }
            
            skillCaster.decrementAllCooldowns(deltaTime: time)
        }
    }

    private func shouldActivate(skill: Skill) -> Bool {
        // Implement logic to determine if a skill should be activated
        // This could be a user input or an AI decision
        // ...
        return true
    }

}
