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
    var skills: [SkillID: Skill] = [:]
    var activationQueue: [SkillID] = []
    var wrapperType: String

    init(id: ComponentID, entity: EntityWrapper, skills: [SkillID: Skill],
         activationQueue: [SkillID], wrapperType: String) {
        self.id = id
        self.entity = entity
        self.skills = skills
        self.activationQueue = activationQueue
        self.wrapperType = wrapperType
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: AnyCodingKey.self)
        try container.encode(id, forKey: AnyCodingKey(stringValue: "id"))
        try container.encode(entity, forKey: AnyCodingKey(stringValue: "entity"))
        try container.encode(wrapperType, forKey: AnyCodingKey(stringValue: "wrapperType"))
        try container.encode(activationQueue, forKey: AnyCodingKey(stringValue: "activationQueue"))

        var skillsContainer = container.nestedContainer(keyedBy: AnyCodingKey.self,
                                                        forKey: AnyCodingKey(stringValue: "skills"))
        for (skillID, skill) in skills {
            let skillName: String = String(describing: type(of: skill))
            try skillsContainer.encode(skillName, forKey: AnyCodingKey(stringValue: skillID))
        }
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
            activationQueue = try container.decode([SkillID].self, forKey: AnyCodingKey(stringValue: "activationQueue"))
        } catch {
            activationQueue = []
        }

        do {
            let skillsContainer = try container.nestedContainer(keyedBy: AnyCodingKey.self,
                                                                    forKey: AnyCodingKey(stringValue: "skills"))
            for key in skillsContainer.allKeys {
                let skillID = key.stringValue
                let skillName = try skillsContainer.decode(String.self, forKey: key)
                if let skillType = NSClassFromString(Constants.directory + skillName) as? Skill.Type {
                    let skillInstance = skillType.init(id: skillID)
                    skills[skillID] = skillInstance
                } else {
                    print("Decoding skills dictionary error")
                }
            }
        } catch {
            skills = [:] // Assign an empty dictionary if field is missing
        }
    }

    func toComponent() -> (Component, Entity)? {
        if wrapperType == Constants.directory + "PlayerWrapper" {
            guard let entity = entity.toEntity() else {
                return nil
            }
            let skillCaster = SkillCaster(id: id, entity: entity)
            skillCaster.skills = skills
            return (skillCaster, entity)
        } else if wrapperType == Constants.directory + "ObstacleWrapper" {
            guard let entity = entity.toEntity() else {
                return nil
            }
            let skillCaster = SkillCaster(id: id, entity: entity)
            skillCaster.skills = skills
            return (skillCaster, entity)
        } else {
            return nil
        }

    }
}
