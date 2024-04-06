//
//  ClientViewModel.swift
//  NinjaWarriors
//
//  Created by Muhammad Reyaaz on 6/4/24.
//

import Foundation
import SwiftUI

@MainActor
final class ClientViewModel: HostClientProtocol {
    var manager: EntitiesManager
    internal var components: [Component] = []
    internal var entity: Entity
    internal var matchId: String
    internal var currPlayerId: String
    private var queue = EventQueue(label: "clientEventQueue")
    private var isAssignedEntity: Bool = false

    init(matchId: String, currPlayerId: String) {
        self.matchId = matchId
        self.currPlayerId = currPlayerId
        self.manager = RealTimeManagerAdapter(matchId: matchId)
        self.entity = Player(id: RandomNonce().randomNonceString())
        self.populate()
        startListening()
    }

    func startListening() {
        print("start listening")
        manager.addEntitiesListener { snapshot in
            //print("snap shot received")
            self.queue.async {
                self.populate()
            }
        }
    }

    func populate() {
        Task {
            do {
                let fetchEntitiesComponents = try await manager.getEntitiesWithComponents(currPlayerId)
                let (fetchEntities, fetchEntityComponents) = fetchEntitiesComponents
                guard let fetchEntity = fetchEntities.first else {
                    return
                }
                if !isAssignedEntity {
                    entity = fetchEntity
                    isAssignedEntity = true
                }
                guard let fetchComponents = fetchEntityComponents[fetchEntity.id] else {
                    return
                }
                process(fetchComponents)
            } catch {
                print("Error fetching client data \(error)")
            }
        }
    }

    func process(_ fetchComponents: [Component]) {
        fetchComponents.forEach { fetchComponent in
            var isSameType = false
            for component in components {
                if ComponentType(type(of: fetchComponent)) == ComponentType(type(of: component)) {
                    isSameType = true
                    component.updateAttributes(fetchComponent)
                }
            }
            if !isSameType {
                components.append(fetchComponent.changeEntity(to: entity))
            }
        }
    }

    func publish() {
        Task {
            do {
                try await manager.uploadEntity(entity: entity, components: components)
            } catch {
                print("Error updating client data \(error)")
            }
        }
    }

    // Only update values that changed
    func updateViews() {
        objectWillChange.send()
    }

    func entityHasRigidAndSprite() -> (sprite: Sprite, position: CGPoint)? {
        guard let rigidbody = components.first(where: { $0 is Collider }) as? Collider,
              let sprite = components.first(where: { $0 is Sprite }) as? Sprite else {
            return nil
        }
        return (sprite: sprite, position: rigidbody.colliderShape.center.get()) // TODO: maybe use rigidbody.position?
    }
    
    func entityHealthComponent() -> Health? {
        guard let health = components.first(where: { $0 is Health }) as? Health else {
            return nil
        }
        return health
    }
}
