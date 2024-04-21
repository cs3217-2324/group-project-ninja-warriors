//
//  RespawnSystem.swift
//  NinjaWarriors
//
//  Created by proglab on 21/4/24.
//

import Foundation

class RespawnSystem: System {
    var manager: EntityComponentManager
    var respawnList: [(Entity, TimeInterval)] = []

    required init(for manager: EntityComponentManager) {
        self.manager = manager
    }

    func update(after time: TimeInterval) {
        let destroyTags = manager.getAllComponents(ofType: DestroyTag.self)
        for destroyTag in destroyTags {
            guard let respawnable = manager.getComponent(ofType: Respawnable.self, for: destroyTag.entity) else {
                continue
            }

            respawnList.append((respawnable.entity, respawnable.respawnTime))
        }

        var updatedList: [(Entity, TimeInterval)] = []
        for (entity, timeLeft) in respawnList {
            let newTimeLeft = timeLeft - time
            if newTimeLeft <= 0 {
                // TODO: Implement respawn
            } else {
                updatedList.append((entity, newTimeLeft))
            }
        }

        respawnList = updatedList
    }
}
