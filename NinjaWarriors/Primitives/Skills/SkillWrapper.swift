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

    enum CodingKeys: CodingKey {
        case id, type, cooldownDuration
    }

    // Encode function
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(type, forKey: .type)
        try container.encode(cooldownDuration, forKey: .cooldownDuration)
    }

    init(id: SkillID, type: String, cooldownDuration: TimeInterval) {
        self.id = id
        self.type = type
        self.cooldownDuration = cooldownDuration
    }
    
    // Decode function
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(SkillID.self, forKey: .id)
        type = try container.decode(String.self, forKey: .type)
        cooldownDuration = try container.decode(TimeInterval.self, forKey: .cooldownDuration)
    }

    // Helper function to convert back to a Skill instance
    func toSkill() -> Skill {
        switch type {
        case "DashSkill":
            return DashSkill(id: id, cooldownDuration: cooldownDuration)
        case "SlashAOESkill":
            return SlashAOESkill(id: id, cooldownDuration: cooldownDuration)
        case "DodgeSkill":
            return DodgeSkill(id: id, cooldownDuration: cooldownDuration)
        case "RefreshCooldownsSkill":
            return RefreshCooldownsSkill(id: id, cooldownDuration: cooldownDuration)
        default:
            fatalError("Unknown Skill type: \(type)")
        }
    }
}

