//
//  EntityComponentManager.swift
//  NinjaWarriors
//
//  Created by Jivesh Mohan on 17/3/24.
//

import Foundation

class EntityComponentManager {
    var entityComponentMap: [EntityID: Set<ComponentID>]
    var entityMap: [EntityID: Entity]
    // alternate organisation is [componentTypeString: [ComponentID: Component]] but idk if there are data locality wins there
    var componentMap: [ComponentID: Component]

    var components: [Component] {
        return Array(componentMap.values)
    }

    init() {
        entityComponentMap = [:]
        entityMap = [:]
        componentMap = [:]
    }

    // MARK: - Entity-related functions
    func entity(with entityID: EntityID) -> Entity? {
        entityMap[entityID]
    }

    func contains(entityID: EntityID) -> Bool {
        entityMap[entityID] != nil && entityComponentMap[entityID] != nil
    }

    func contains(entity: Entity) -> Bool {
        contains(entityID: entity.id)
    }

    func add(entity: Entity) {
        assertRepresentation()

        entityMap[entity.id] = entity
        entityComponentMap[entity.id] = []

        let newComponents = entity.getInitializingComponents()
        newComponents.forEach({add(component: $0, to: entity)})

        assertRepresentation()
    }

    func remove(entity: Entity) {
        assertRepresentation()

        removeComponents(from: entity)
        entityMap[entity.id] = nil
        entityComponentMap[entity.id] = nil

        assertRepresentation()
    }

    // MARK: - Component-related functions
    /// Checks if an entity already has a component of a given type
    func containsComponent<T: Component>(ofType type: T.Type, for entity: Entity) -> Bool {
        return entityComponentMap[entity.id]?.contains(where: {componentMap[$0] is T}) ?? false
    }

    func getComponentFromId<T: Component>(ofType type: T.Type, of entityID: EntityID) -> T? {
        guard let entity = entity(with: entityID) else {
            return nil
        }
        return getComponent(ofType: type, for: entity)
    }

    private func add(component: Component, to entity: Entity) {
        assertRepresentation()

        guard entityMap[entity.id] != nil else {
            assertionFailure("Entity not found")
            return
        }
        component.entity = entity
        componentMap[component.id] = component
        entityComponentMap[entity.id]?.insert(component.id)

        assertRepresentation()
    }

    func getComponent<T: Component>(ofType: T.Type, for entity: Entity) -> T? {
        guard let entityComponentIDs = entityComponentMap[entity.id] else {
            return nil
        }

        let componentIDs = entityComponentIDs.filter({componentMap[$0] is T})

        assert(componentIDs.count <= 1, "Entity has multiple components of the same type")

        guard let componentID = componentIDs.first else {
            return nil
        }

        return componentMap[componentID] as? T
    }


    func getAllComponents<T: Component>(ofType: T.Type) -> [T] {
        return componentMap.values.compactMap({$0 as? T})
    }

    private func remove(component: Component, from entity: Entity) {
        guard entityMap[entity.id] != nil && entityComponentMap[entity.id] != nil else {
            assertionFailure("Entity not found in removeComponent call")
            return
        }
        componentMap[component.id] = nil
        entityComponentMap[entity.id]?.remove(component.id)
    }

    private func removeComponents(from entity: Entity) {
        let targetComponentIDs = entityComponentMap[entity.id] ?? []
        let targetComponents = targetComponentIDs.compactMap({componentMap[$0]})
        targetComponents.forEach({remove(component: $0, from: entity)})
    }

    func remove<T: Component>(ofComponentType: T.Type, from entity: Entity) {
        let component = getComponent(ofType: T.self, for: entity)
        if let component = component {
            remove(component: component, from: entity)
        }
    }

    // All IDs in entityComponentMap should exist in one of the two maps, vice versa
    private func assertRepresentation() {
        for (entityID, componentIDs) in entityComponentMap {
            assert(entityMap[entityID] != nil)
            for componentID in componentIDs {
                assert(componentMap[componentID] != nil)
            }
        }

        for (entityID, _) in entityMap {
            assert(entityComponentMap[entityID] != nil)
        }

        let allComponentIDs = entityComponentMap.values.flatMap({$0})
        for (componentID, _) in componentMap {
            assert(allComponentIDs.contains(componentID))
        }

        // TODO: check that no entity has multiple components of the same type
    }
}
