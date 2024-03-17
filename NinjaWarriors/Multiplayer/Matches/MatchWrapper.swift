//
//  MatchWrapper.swift
//  NinjaWarriors
//
//  Created by Muhammad Reyaaz on 16/3/24.
//

import Foundation

struct MatchWrapper: FactoryWrapper, Codable {
    typealias Item = MatchWrapper
    let id: String
    let count: Int
    let readyPlayers: [String]

    init(id: String, count: Int, readyPlayers: [String]) {
        self.id = id
        self.count = count
        self.readyPlayers = readyPlayers
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: AnyCodingKey.self)
        id = try container.decode(String.self, forKey: AnyCodingKey(stringValue: "id"))
        count = try container.decode(Int.self, forKey: AnyCodingKey(stringValue: "count"))
        readyPlayers = try container.decode([String].self, forKey: AnyCodingKey(stringValue: "ready_players"))
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: AnyCodingKey.self)
        try container.encode(id, forKey: AnyCodingKey(stringValue: "id"))
        try container.encode(count, forKey: AnyCodingKey(stringValue: "count"))
        try container.encode(readyPlayers, forKey: AnyCodingKey(stringValue: "ready_players"))
    }

    func toMatch() -> Match {
        Match(id: id, count: count, readyPlayers: readyPlayers)
    }
}
