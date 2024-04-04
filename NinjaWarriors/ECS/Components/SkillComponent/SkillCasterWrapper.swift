//
//  SkillCasterWrapper.swift
//  NinjaWarriors
//
//  Created by Muhammad Reyaaz on 23/3/24.
//

import Foundation

struct SkillCasterWrapper: ComponentWrapper {

    var id: ComponentID
    var entity: EntityWrapper
    var skills: [SkillID: SkillWrapper] = [:]
    var skillCooldowns: [SkillID: TimeInterval] = [:]
    var activationQueue: [SkillID] = []

    init(id: ComponentID, entity: EntityWrapper, skills: [SkillID: SkillWrapper], skillCooldowns: [SkillID: TimeInterval], activationQueue: [SkillID]) {
        self.id = id
        self.entity = entity
        self.skills = skills
        self.skillCooldowns = skillCooldowns
        self.activationQueue = activationQueue
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: AnyCodingKey.self)
        try container.encode(id, forKey: AnyCodingKey(stringValue: "id"))
        try container.encode(entity, forKey: AnyCodingKey(stringValue: "entity"))
        try container.encode(skillCooldowns, forKey: AnyCodingKey(stringValue: "skillCooldowns"))
        try container.encode(activationQueue, forKey: AnyCodingKey(stringValue: "activationQueue"))

        var skillsContainer = container.nestedContainer(keyedBy: AnyCodingKey.self,
                                                            forKey: AnyCodingKey(stringValue: "skills"))
        for (skillID, skillWrapper) in skills {
            try skillsContainer.encode(skillWrapper, forKey: AnyCodingKey(stringValue: skillID))
        }
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: AnyCodingKey.self)
        id = try container.decode(ComponentID.self, forKey: AnyCodingKey(stringValue: "id"))
        entity = try container.decode(EntityWrapper.self, forKey: AnyCodingKey(stringValue: "entity"))
        skillCooldowns = try container.decode([SkillID: TimeInterval].self, forKey: AnyCodingKey(stringValue: "skillCooldowns"))
        activationQueue = try container.decodeIfPresent([SkillID].self, forKey: AnyCodingKey(stringValue: "activationQueue")) ?? []

        let skillsContainer = try container.nestedContainer(keyedBy: AnyCodingKey.self, forKey: AnyCodingKey(stringValue: "skills"))
        for key in skillsContainer.allKeys {
            let skillWrapper = try skillsContainer.decode(SkillWrapper.self, forKey: key)
            skills[key.stringValue] = skillWrapper
        }
    }

    func toComponent() -> Component? {
        guard let entityObj = entity.toEntity() else {
            return nil
        }
        let skillCaster = SkillCaster(id: id, entity: entityObj)

        // Reconstruct skills from SkillWrapper
        var reconstructedSkills: [SkillID: Skill] = [:]
        for (skillID, skillWrapper) in skills {
            reconstructedSkills[skillID] = skillWrapper.toSkill()
        }
        skillCaster.skills = reconstructedSkills

        skillCaster.skillCooldowns = skillCooldowns
        skillCaster.activationQueue = activationQueue

        return skillCaster
    }
}
