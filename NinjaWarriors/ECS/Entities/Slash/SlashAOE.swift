//
//  SlashAOE.swift
//  NinjaWarriors
//
//  Created by proglab on 23/3/24.
//

import Foundation

class SlashAOE: Entity {
    let id: EntityID
    var casterEntity: Entity

    init(id: EntityID, casterEntity: Entity) {
        self.id = id
        self.casterEntity = casterEntity
    }

    func getInitializingComponents() -> [Component] {
        let shape = Shape(center: Constants.playerTwoPosition, halfLength: Constants.defaultSize)
        let collider = Collider(id: RandomNonce().randomNonceString(), entity: self, colliderShape: shape)
        return [collider]
    }

    func deepCopy() -> Entity {
        SlashAOE(id: id, casterEntity: casterEntity.deepCopy())
    }

    func wrapper() -> EntityWrapper? {
        guard let casterEntityWrapper = casterEntity.wrapper() else {
            return nil
        }
        return SlashaoeWrapper(id: id, casterEntity: casterEntityWrapper)
    }
}
