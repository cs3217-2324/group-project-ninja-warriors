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
    var wrapperType: String

    init(id: ComponentID, entity: EntityWrapper, skills: [SkillID: SkillWrapper],
         skillCooldowns: [SkillID: TimeInterval],
         activationQueue: [SkillID], wrapperType: String) {
        self.id = id
        self.entity = entity
        self.skills = skills
        self.skillCooldowns = skillCooldowns
        self.activationQueue = activationQueue
        self.wrapperType = wrapperType
    }


    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: AnyCodingKey.self)
        try container.encode(id, forKey: AnyCodingKey(stringValue: "id"))
        try container.encode(entity, forKey: AnyCodingKey(stringValue: "entity"))
        try container.encode(wrapperType, forKey: AnyCodingKey(stringValue: "wrapperType"))

        var skillCooldownsContainer = container.nestedContainer(keyedBy: AnyCodingKey.self,
                                                        forKey: AnyCodingKey(stringValue: "skillCooldowns"))

        for (skillID, timeInterval) in skillCooldowns {
            try skillCooldownsContainer.encode(timeInterval, forKey: AnyCodingKey(stringValue: skillID))
        }

        var skillsContainer = container.nestedContainer(keyedBy: AnyCodingKey.self,
                                                        forKey: AnyCodingKey(stringValue: "skills"))

        for (skillID, skillWrapper) in skills {
            try skillsContainer.encode(skillWrapper, forKey: AnyCodingKey(stringValue: skillID))
        }
        try container.encode(activationQueue, forKey: AnyCodingKey(stringValue: "activationQueue"))
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: AnyCodingKey.self)
        id = try container.decode(ComponentID.self, forKey: AnyCodingKey(stringValue: "id"))

        wrapperType = try container.decode(String.self, forKey: AnyCodingKey(stringValue: "wrapperType"))

        guard let wrapperClass = NSClassFromString(wrapperType) as? EntityWrapper.Type else {
            throw NSError(domain: "NinjaWarriors.Wrapper", code: 1, userInfo: [NSLocalizedDescriptionKey: "Invalid wrapper type: \(wrapperType)"])
        }

        entity = try container.decode(wrapperClass.self, forKey: AnyCodingKey(stringValue: "entity"))

        do {
            activationQueue = try container.decodeIfPresent([SkillID].self, forKey: AnyCodingKey(stringValue: "activationQueue")) ?? []
        } catch {
            activationQueue = []
        }

        do {
            let skillsContainer = try container.nestedContainer(keyedBy: AnyCodingKey.self,
                                                                forKey: AnyCodingKey(stringValue: "skills"))
            for key in skillsContainer.allKeys {
                let skillID = key.stringValue
                let skillWrapper = try skillsContainer.decode(SkillWrapper.self, forKey: key)
                skills[skillID] = skillWrapper
            }
        } catch {
            skills = [:] // Assign an empty dictionary if field is missing
        }


        do {
            let skillCooldownsContainer = try container.nestedContainer(keyedBy: AnyCodingKey.self,
                                                                forKey: AnyCodingKey(stringValue: "skillCooldowns"))
            for key in skillCooldownsContainer.allKeys {
                let skillID = key.stringValue
                let timeInterval = try skillCooldownsContainer.decode(TimeInterval.self, forKey: key)
                skillCooldowns[skillID] = timeInterval
            }
        } catch {
            skillCooldowns = [:] // Assign an empty dictionary if field is missing
        }


    }

    func toComponent(entity: Entity) -> Component? {
        let skillCaster = SkillCaster(id: id, entity: entity)

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
