//
//  SkillCaster.swift
//  NinjaWarriors
//
//  Created by Joshen on 19/3/24.
//

import Foundation

class SkillCaster: Component {
    var skills: [SkillID: Skill] = [:]
    var skillCooldowns: [SkillID: TimeInterval] = [:]
    var activationQueue: [SkillID] = []

    init(id: ComponentID, entity: Entity, skills: [Skill] = []) {
        super.init(id: id, entity: entity) // Player in most cases
        for skill in skills {
            self.skills[skill.id] = skill
            self.skillCooldowns[skill.id] = 0.0
        }
    }

    func queueSkillActivation(_ skillId: SkillID) {
        if let cooldown = skillCooldowns[skillId], cooldown <= 0 {
            activationQueue.append(skillId)
        }
    }

    func decrementAllCooldowns(deltaTime: TimeInterval) {
        for (skillId, cooldown) in skillCooldowns {
            let newCooldown = max(0, cooldown - deltaTime)
            skillCooldowns[skillId] = newCooldown
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

    override func updateAttributes(_ newSkillCaster: Component) {
        guard let newSkillCaster = newSkillCaster as? SkillCaster else {
            return
        }
        self.skills = newSkillCaster.skills
        self.activationQueue = newSkillCaster.activationQueue
    }

    override func wrapper() -> ComponentWrapper? {
        guard let entity = entity.wrapper() else {
            return nil
        }
        return SkillCasterWrapper(id: id, entity: entity, skills: skills, activationQueue: activationQueue,
                                  wrapperType: NSStringFromClass(type(of: entity)))
    }
}
