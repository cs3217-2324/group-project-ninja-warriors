//
//  SkillWrapper.swift
//  NinjaWarriors
//
//  Created by Joshen on 4/4/24.
//

import Foundation

struct SkillWrapper: Codable {
    var id: SkillID
    var type: String
    var cooldownDuration: TimeInterval

    init(id: SkillID, type: String, cooldownDuration: TimeInterval) {
        self.id = id
        self.type = type
        self.cooldownDuration = cooldownDuration
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: AnyCodingKey.self)
        try container.encode(id, forKey: AnyCodingKey(stringValue: "id"))
        try container.encode(type, forKey: AnyCodingKey(stringValue: "type"))
        try container.encode(cooldownDuration, forKey: AnyCodingKey(stringValue: "cooldownDuration"))
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: AnyCodingKey.self)
        id = try container.decode(SkillID.self, forKey: AnyCodingKey(stringValue: "id"))
        type = try container.decode(String.self, forKey: AnyCodingKey(stringValue: "type"))
        cooldownDuration = try container.decode(TimeInterval.self,
                                                forKey: AnyCodingKey(stringValue: "cooldownDuration"))
    }

    func toSkill() -> Skill {
        if type == "DashSkill" {
            return DashSkill(id: id, cooldownDuration: cooldownDuration)
        } else if type == "SlashAOESkill" {
            return SlashAOESkill(id: id, cooldownDuration: cooldownDuration)
        } else if type == "DodgeSkill" {
            return DodgeSkill(id: id, cooldownDuration: cooldownDuration)
        } else if type == "RefreshCooldownsSkill" {
            return RefreshCooldownsSkill(id: id, cooldownDuration: cooldownDuration)
        } else {
            fatalError("Unknown Skill type: \(type)")
        }
    }
}
