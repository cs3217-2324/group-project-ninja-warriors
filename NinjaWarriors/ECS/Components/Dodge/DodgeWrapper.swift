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

    init(id: ComponentID, entity: EntityWrapper, isEnabled: Bool, wrapperType: String) {
        self.id = id
        self.entity = entity
        self.isEnabled = isEnabled
        self.wrapperType = wrapperType
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: AnyCodingKey.self)
        try container.encode(id, forKey: AnyCodingKey(stringValue: "id"))
        try container.encode(entity, forKey: AnyCodingKey(stringValue: "entity"))
        try container.encode(entity, forKey: AnyCodingKey(stringValue: "isEnabled"))
        try container.encode(wrapperType, forKey: AnyCodingKey(stringValue: "wrapperType"))
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
    }

    /*
    func toComponent() -> (Component, Entity)? {
        if let entity = entity as? PlayerWrapper {
            guard let unwrappedEntity = entity.toEntity() else {
                return nil
            }
            return (Dodge(id: id, entity: unwrappedEntity, isEnabled: isEnabled), unwrappedEntity)
        } else if let entity = entity as? ObstacleWrapper {
            guard let unwrappedEntity = entity.toEntity() else {
                return nil
            }
            return (Dodge(id: id, entity: unwrappedEntity, isEnabled: isEnabled), unwrappedEntity)
        } else {
            return nil
        }
    }
    */

    func toComponent() -> (Component, Entity)? {
        if wrapperType == Constants.directory + "PlayerWrapper" {
            guard let unwrappedEntity = entity.toEntity() else {
                return nil
            }
            return (Dodge(id: id, entity: unwrappedEntity, isEnabled: isEnabled), unwrappedEntity)
        } else if wrapperType == Constants.directory + "ObstacleWrapper" {
            guard let unwrappedEntity = entity.toEntity() else {
                return nil
            }
            return (Dodge(id: id, entity: unwrappedEntity, isEnabled: isEnabled), unwrappedEntity)
        } else {
            return nil
        }
    }
}
