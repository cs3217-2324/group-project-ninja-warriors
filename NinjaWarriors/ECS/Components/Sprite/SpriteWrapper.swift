//
//  SpriteWrapper.swift
//  NinjaWarriors
//
//  Created by Muhammad Reyaaz on 28/3/24.
//

import Foundation

struct SpriteWrapper: ComponentWrapper {
    var id: ComponentID
    var entity: EntityWrapper
    var image: String
    var width: CGFloat
    var height: CGFloat
    var wrapperType: String

    init(id: ComponentID, entity: EntityWrapper, image: String,
         width: CGFloat, height: CGFloat, wrapperType: String) {
        self.id = id
        self.entity = entity
        self.image = image
        self.width = width
        self.height = height
        self.wrapperType = wrapperType
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: AnyCodingKey.self)
        try container.encode(id, forKey: AnyCodingKey(stringValue: "id"))
        try container.encode(entity, forKey: AnyCodingKey(stringValue: "entity"))
        try container.encode(image, forKey: AnyCodingKey(stringValue: "image"))
        try container.encode(width, forKey: AnyCodingKey(stringValue: "width"))
        try container.encode(height, forKey: AnyCodingKey(stringValue: "height"))
        try container.encode(wrapperType, forKey: AnyCodingKey(stringValue: "wrapperType"))
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: AnyCodingKey.self)
        id = try container.decode(ComponentID.self, forKey: AnyCodingKey(stringValue: "id"))
        wrapperType = try container.decode(String.self, forKey: AnyCodingKey(stringValue: "wrapperType"))

        guard let wrapperClass = NSClassFromString(wrapperType) as? EntityWrapper.Type else {
            throw NSError(domain: "NinjaWarriors.Wrapper",
                          code: 1, userInfo: [NSLocalizedDescriptionKey: "Invalid wrapper type: \(wrapperType)"])
        }

        entity = try container.decode(wrapperClass.self, forKey: AnyCodingKey(stringValue: "entity"))

        image = try container.decode(String.self, forKey: AnyCodingKey(stringValue: "image"))
        width = try container.decode(CGFloat.self, forKey: AnyCodingKey(stringValue: "width"))
        height = try container.decode(CGFloat.self, forKey: AnyCodingKey(stringValue: "height"))
    }

    func toComponent(entity: Entity) -> Component? {
        return Sprite(id: id, entity: entity, image: image, width: width, height: height)
    }

}
