//
//  SkillCaster.swift
//  NinjaWarriors
//
//  Created by Joshen on 19/3/24.
//

import Foundation

class SkillCaster: Component {
    var skills: [SkillID: Skill] = [:]
    var activationQueue: [SkillID] = []

    init(id: ComponentID, entity: Entity, skills: [Skill] = []) {
        super.init(id: id, entity: entity) // Player in most cases
        for skill in skills {
            self.skills[skill.id] = skill
        }
    }

    func queueSkillActivation(_ skillId: SkillID) {
        activationQueue.append(skillId)
    }

    func decrementAllCooldowns(deltaTime: TimeInterval) {
        for (_, skill) in skills {
            skill.decrementCooldown(deltaTime: deltaTime)
        }
    }

    func decrementSkillCooldown(skillId: SkillID, deltaTime: TimeInterval) {
        skills[skillId]?.decrementCooldown(deltaTime: deltaTime)
    }

    func addSkill(_ skill: Skill) {
        skills[skill.id] = skill
    }

    func removeSkill(withId id: SkillID) {
        skills.removeValue(forKey: id)
    }

    override func wrapper() -> ComponentWrapper? {
        guard let entity = entity.wrapper() else {
            return nil
        }

        if activationQueue == [] {
            activationQueue = ["1"]
        }

        if skills.isEmpty {
            skills = ["1": SlashAOESkill(id: "1")]
        }

        return SkillCasterWrapper(id: id, entity: entity, skills: skills, activationQueue: activationQueue)
    }
}
