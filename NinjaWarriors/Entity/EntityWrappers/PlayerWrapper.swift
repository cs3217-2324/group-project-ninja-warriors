//
//  PlayerWrapper.swift
//  NinjaWarriors
//
//  Created by Muhammad Reyaaz on 15/3/24.
//

import Foundation

struct PlayerWrapper: FactoryWrapper, Codable {
    typealias T = PlayerWrapper
    let id: Int
    let gameObject: GameObjectWrapper

    init(id: Int, gameObject: GameObjectWrapper) {
        self.id = id
        self.gameObject = gameObject
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: AnyCodingKey.self)
        id = try container.decode(Int.self, forKey: AnyCodingKey(stringValue: "id"))
        gameObject = try container.decode(GameObjectWrapper.self,
                                   forKey: AnyCodingKey(stringValue: "gameObject"))
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: AnyCodingKey.self)
        try container.encode(id, forKey: AnyCodingKey(stringValue: "id"))
        try container.encode(gameObject, forKey: AnyCodingKey(stringValue: "gameObject"))
    }

    func toPlayer() -> Player {
        Player(id: id, gameObject: gameObject.toGameObject())
    }
}
