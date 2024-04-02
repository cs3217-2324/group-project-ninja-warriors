//
//  SkillCasterSystem.swift
//  NinjaWarriors
//
//  Created by Joshen Lim on 21/3/24.
//

import Foundation

// The system responsible for handling skill casting logic
class SkillCasterSystem: System {
    var manager: EntityComponentManager

    required init(for manager: EntityComponentManager) {
        self.manager = manager
    }

    func update(after time: TimeInterval) {
        let skillCasters = manager.getAllComponents(ofType: SkillCaster.self)
        for skillCaster in skillCasters {
            while !skillCaster.activationQueue.isEmpty {
                let skillId = skillCaster.activationQueue.removeFirst()
                
                guard let skill = skillCaster.skills[skillId] else { continue }
                
                if (skill.isOnCooldown()) {
                    print("[Skill <\(skill.id)>] On cooldown!")
                    continue
                }
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
