//
//  DodgeWrapper.swift
//  NinjaWarriors
//
//  Created by Joshen on 1/4/24.
//

import Foundation

struct DodgeWrapper: ComponentWrapper {
    var id: ComponentID
    var entity: EntityWrapper
    var isEnabled: Bool
    var wrapperType: String
    var invulnerabilityDuration: TimeInterval
    var elapsedTimeSinceEnabled: CGFloat

    init(id: ComponentID, entity: EntityWrapper, isEnabled: Bool, wrapperType: String, invulnerabilityDuration: TimeInterval, elapsedTimeSinceEnabled: CGFloat) {
        self.id = id
        self.entity = entity
        self.isEnabled = isEnabled
        self.wrapperType = wrapperType
        self.invulnerabilityDuration = invulnerabilityDuration
        self.elapsedTimeSinceEnabled = elapsedTimeSinceEnabled
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: AnyCodingKey.self)
        try container.encode(id, forKey: AnyCodingKey(stringValue: "id"))
        try container.encode(entity, forKey: AnyCodingKey(stringValue: "entity"))
        try container.encode(isEnabled, forKey: AnyCodingKey(stringValue: "isEnabled"))
        try container.encode(wrapperType, forKey: AnyCodingKey(stringValue: "wrapperType"))
        try container.encode(invulnerabilityDuration,
                             forKey: AnyCodingKey(stringValue: "invulnerabilityDuration"))
        try container.encode(elapsedTimeSinceEnabled,
                             forKey: AnyCodingKey(stringValue: "elapsedTimeSinceEnabled"))
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: AnyCodingKey.self)
        id = try container.decode(ComponentID.self, forKey: AnyCodingKey(stringValue: "id"))
        wrapperType = try container.decode(String.self, forKey: AnyCodingKey(stringValue: "wrapperType"))

        guard let wrapperClass = NSClassFromString(wrapperType) as? EntityWrapper.Type else {
            throw NSError(domain: "NinjaWarriors.Wrapper", code: 1, userInfo: [NSLocalizedDescriptionKey: "Invalid wrapper type: \(wrapperType)"])
        }
        entity = try container.decode(wrapperClass.self, forKey: AnyCodingKey(stringValue: "entity"))
        isEnabled = try container.decode(Bool.self, forKey: AnyCodingKey(stringValue: "isEnabled"))
        invulnerabilityDuration = try container.decode(TimeInterval.self,
                                                       forKey: AnyCodingKey(stringValue: "invulnerabilityDuration"))
        elapsedTimeSinceEnabled = try container.decode(CGFloat.self, forKey: AnyCodingKey(stringValue: "elapsedTimeSinceEnabled"))
    }

    func toComponent(entity: Entity) -> Component? {
        return Dodge(id: id, entity: entity, isEnabled: isEnabled,
                     invulnerabilityDuration: invulnerabilityDuration,
                     elapsedTimeSinceEnabled: elapsedTimeSinceEnabled)
    }
}
