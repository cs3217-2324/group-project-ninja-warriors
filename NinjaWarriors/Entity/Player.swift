//
//  Player.swift
//  NinjaWarriors
//
//  Created by Muhammad Reyaaz on 15/3/24.
//

import Foundation

// TODO: Replace hardcoded player with player from ECS

class Player {
    let id: Int
    let gameObject: GameObject

    init(id: Int, gameObject: GameObject) {
        self.id = id
        self.gameObject = gameObject
    }

    func getPosition() -> CGPoint {
        gameObject.getCenter()
    }

    func changePosition(to center: Point) {
        gameObject.center = center
    }

    func toPlayerWrapper() -> PlayerWrapper {
        PlayerWrapper(id: id, gameObject: gameObject.toGameObjectWrapper())
    }
}
