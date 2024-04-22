//
//  CollectionSystem.swift
//  NinjaWarriors
//
//  Created by proglab on 21/4/24.
//

import Foundation

class CollectionSystem: System {
    var manager: EntityComponentManager

    required init(for manager: EntityComponentManager) {
        self.manager = manager
    }

    func update(after time: TimeInterval) {
        let collectors = manager.getAllComponents(ofType: Collector.self)
        for collector in collectors {
            collector.updateTime(time)
            if let collider = manager.getComponent(ofType: Collider.self, for: collector.entity),
               let collidedEntityID = collider.collidedEntities.first,
               let collidedEntity = manager.entity(with: collidedEntityID),
               let collectable = manager.getComponent(ofType: Collectable.self, for: collidedEntity) {
                collector.addItem(of: collectable.entityType, count: 1, currEntity: collidedEntity.id)
                manager.add(entity: collectable.entity, components: [DestroyTag(id: RandomNonce().randomNonceString(), entity: collectable.entity)])
            }
        }
    }
}
