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

    init(id: ComponentID, entity: Entity, skills: [SkillID: Skill],
         skillCooldowns: [SkillID: TimeInterval],
         activationQueue: [SkillID]) {
        self.skills = skills
        self.skillCooldowns = skillCooldowns
        self.activationQueue = activationQueue
        super.init(id: id, entity: entity)
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

    func resetSkillCooldown(skillId: SkillID) {
        skillCooldowns[skillId] = 0
    }

    // Call this method when activating a skill to start its cooldown
    func startSkillCooldown(skillId: SkillID, cooldownDuration: TimeInterval) {
        skillCooldowns[skillId] = cooldownDuration
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
        self.skillCooldowns = newSkillCaster.skillCooldowns
        self.activationQueue = newSkillCaster.activationQueue
    }

    override func changeEntity(to entity: Entity) -> Component {
        SkillCaster(id: self.id, entity: entity, skills: self.skills,
                    skillCooldowns: self.skillCooldowns,
                    activationQueue: self.activationQueue)
    }

    override func wrapper() -> ComponentWrapper? {
        guard let entity = entity.wrapper() else {
            return nil
        }

        var wrappedSkills: [SkillID: SkillWrapper] = [:]
        for (skillID, skill) in skills {
            wrappedSkills[skillID] = skill.wrapper()
        }

        return SkillCasterWrapper(id: id, entity: entity, skills: wrappedSkills,
                                  skillCooldowns: skillCooldowns, activationQueue: activationQueue,
                                  wrapperType: NSStringFromClass(type(of: entity)))
    }
}
