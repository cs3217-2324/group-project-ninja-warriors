//
//  Player.swift
//  NinjaWarriors
//
//  Created by Muhammad Reyaaz on 15/3/24.
//

import Foundation

// TODO: Replace hardcoded player with player from ECS

struct Player {
    let id: Int
    let gameObject: GameObject

    init(id: Int, gameObject: GameObject) {
        self.id = id
        self.gameObject = gameObject
    }

    func getPosition() -> CGPoint {
        gameObject.getCenter()
    }

    func toPlayerWrapper() -> PlayerWrapper {
        PlayerWrapper(id: id, gameObject: gameObject.toGameObjectWrapper())
    }
}
