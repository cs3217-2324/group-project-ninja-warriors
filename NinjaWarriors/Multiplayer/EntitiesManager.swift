//
//  EntitiesManager.swift
//  NinjaWarriors
//
//  Created by Muhammad Reyaaz on 16/3/24.
//

import Foundation

protocol EntitiesManager {
    func getAllEntities() async throws -> [Entity]?
    func getEntity(entityId: EntityID) async throws -> Entity?
    func uploadEntity(entity: Entity, entityName: String, component: Component?) async throws
    func addPlayerListeners() -> [PlayerPublisher]
}
