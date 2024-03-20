//
//  EntitiesManager.swift
//  NinjaWarriors
//
//  Created by Muhammad Reyaaz on 16/3/24.
//

import Foundation

protocol EntitiesManager {
    func uploadEntity(entity: Entity) async throws
    func getEntity(entityId: String) async throws -> Entity
    func updateEntity(id: String, position: Point) async throws
    func getAllEntities(with ids: [String]) async throws -> [Entity]
    func addListenerForAllEntities() -> EntityPublisher
}
