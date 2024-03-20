//
//  PlayerWrapper.swift
//  NinjaWarriors
//
//  Created by Muhammad Reyaaz on 15/3/24.
//

import Foundation

struct PlayerWrapper: FactoryWrapper, Codable {
    typealias Item = PlayerWrapper
    let id: String
    let shape: ShapeWrapper

    init(id: String, shape: ShapeWrapper) {
        self.id = id
        self.shape = shape
    }

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

    func toPlayer() -> Player {
        Player(id: id, Shape: shape.toShape(), skills: []) // TODO: Create Entity wrapper to wrap skills and players
    }
}
