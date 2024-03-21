//
//  PlayerWrapper.swift
//  NinjaWarriors
//
//  Created by Muhammad Reyaaz on 15/3/24.
//

import Foundation

class PlayerWrapper: EntityWrapper {
    /*@CodableWrapper*/ var components: [ComponentWrapper]?

    init(id: EntityID, shape: ShapeWrapper, components: [ComponentWrapper]? = nil) {
        // self.id = id
        // self.shape = shape
        self.components = components
        super.init(id: id, shape: shape)
    }

    required init(from decoder: Decoder) throws {
        try super.init(from: decoder)
    }

    override func toEntity() -> Entity? {
        var componentsUnwrap: [Component] = []
        guard let components = components else {
            return Player(id: id, shape: shape.toShape())
        }
        for component in components {
            if let componentUnwrap = component.toComponent() {
                componentsUnwrap.append(componentUnwrap)
            }
        }
        return Player(id: id, shape: shape.toShape(), components: componentsUnwrap)
    }
}

    /*
    required init(from decoder: Decoder) throws {
        fatalError("init(from:) has not been implemented")
    }

    /*
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: AnyCodingKey.self)
        id = try container.decode(String.self, forKey: AnyCodingKey(stringValue: "id"))
        shape = try container.decode(ShapeWrapper.self,
                                   forKey: AnyCodingKey(stringValue: "Shape"))
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: AnyCodingKey.self)
        try container.encode(id, forKey: AnyCodingKey(stringValue: "id"))
        try container.encode(shape, forKey: AnyCodingKey(stringValue: "Shape"))
    }
    */
}
*/
