//
//  LastManStandingMode.swift
//  NinjaWarriors
//
//  Created by proglab on 14/4/24.
//

import Foundation

class LastManStandingMode: GameMode {
    var hasStarted: Bool = false

    func isGameOver(for gameWorld: GameWorld) -> Bool {
        guard hasStarted else {
            return false
        }

        let playerComponents = gameWorld.entityComponentManager.getAllComponents(ofType: PlayerComponent.self)
        return playerComponents.count <= 1
    }

    func start() {
        hasStarted = true
    }
}
