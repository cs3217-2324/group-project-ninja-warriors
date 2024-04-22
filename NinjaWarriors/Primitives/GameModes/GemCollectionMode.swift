//
//  GemCollectionMode.swift
//  NinjaWarriors
//
//  Created by proglab on 21/4/24.
//

import Foundation

class GemCollectionMode: GameMode {
    var hasStarted: Bool = false

    func isGameOver(for gameWorld: GameWorld) -> Bool {
        guard hasStarted else {
            return false
        }

        let collectors = gameWorld.entityComponentManager.getAllComponents(ofType: Collector.self)
        for collector in collectors where collector.countItem(of: "Gem") >= Constants.gemCountToWin {
            return true
        }

        let playerComponents = gameWorld.entityComponentManager.getAllComponents(ofType: PlayerComponent.self)
        return playerComponents.count <= 1
    }

    func start() {
        hasStarted = true
    }
}
