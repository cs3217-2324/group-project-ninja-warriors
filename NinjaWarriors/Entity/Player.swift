//
//  Player.swift
//  NinjaWarriors
//
//  Created by Muhammad Reyaaz on 15/3/24.
//

import Foundation

class Player {
    let id: String
    let gameObject: GameObject

    init(id: String, gameObject: GameObject) {
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
