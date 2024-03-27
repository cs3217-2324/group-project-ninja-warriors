//
//  EntityComponentManager.swift
//  NinjaWarriors
//
//  Created by Jivesh Mohan on 17/3/24.
//

import Foundation

class EntityComponentManager {
    var entityComponentMap: [EntityID: Set<Component>]
    var entityMap: [EntityID: Entity]
    var componentMap: [ComponentType: Set<Component>]

    var components: [Component] {
        var allComponents: [Component] = []
        for (_, componentArray) in componentMap {
            allComponents.append(contentsOf: componentArray)
        }
        return allComponents
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
        print("[EntityComponentManager] add", entity)
        entityMap[entity.id] = entity
        entityComponentMap[entity.id] = []

        // MARK: Insert intializing components of entity
        let newComponents = entity.getInitializingComponents()
        print("[EntityComponentManager] new", newComponents)
        newComponents.forEach({add(component: $0, to: entity)})

        print("[EntityComponentManager] entityMap", entityMap)
        print("[EntityComponentManager] entityComponentMap", entityComponentMap)

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
        guard let components = entityComponentMap[entity.id] else {
            return false
        }
        return components.contains { $0 is T }
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

        componentMap[ComponentType(type(of: component))]?.insert(component)
        entityComponentMap[entity.id]?.insert(component)

        assertRepresentation()
    }

    func getComponent<T: Component>(ofType: T.Type, for entity: Entity) -> T? {
        guard let entityComponents = entityComponentMap[entity.id] else {
            return nil
        }

        let components = entityComponents.filter({$0 is T})

        assert(components.count <= 1, "Entity has multiple components of the same type")

        guard let component = components.first else {
            return nil
        }

        return component as? T
    }

    func getAllComponents(for entity: Entity) -> [Component] {
        guard let components = entityComponentMap[entity.id] else { return [] }
        return Array(components)
    }

    func getAllComponents<T: Component>(ofType: T.Type) -> [T] {
        guard let componentsWithType = componentMap[ComponentType(ofType)] else {
            return []
        }
        guard let components = Array(componentsWithType) as? [T] else {
            return []
        }
        return components
    }

    private func remove(component: Component, from entity: Entity) {
        guard entityMap[entity.id] != nil && entityComponentMap[entity.id] != nil else {
            assertionFailure("Entity not found in removeComponent call")
            return
        }
        entityComponentMap[entity.id]?.remove(component)
        componentMap[ComponentType(type(of: component))]?.remove(component)
    }

    private func removeComponents(from entity: Entity) {
        let entityID = entity.id
        if let componentsToRemove = entityComponentMap[entityID] {
            for component in componentsToRemove {
                let componentType = type(of: component)

                componentMap[ComponentType(componentType)]?.remove(component)
            }
        }
    }

    func remove<T: Component>(ofComponentType: T.Type, from entity: Entity) {
        let component = getComponent(ofType: T.self, for: entity)
        if let component = component {
            remove(component: component, from: entity)
        }
    }

    func getAllEntities() -> [Entity] {
        Array(entityMap.values)
    }

    func setEntities(to entities: [Entity]) {
        reset()
        for entity in entities {
            add(entity: entity)
        }
    }

    func reset() {
        entityComponentMap = [:]
        entityMap = [:]
        componentMap = [:]
    }

    private func assertRepresentation() {
        // Assert no entityId has two components of the same type
        for (entityID, components) in entityComponentMap {
            var componentTypes = Set<ComponentType>()
            for component in components {
                let componentType = ComponentType(type(of: component))
                assert(!componentTypes.contains(componentType),
                       "Error: EntityID \(entityID) has two components of the same type")
                componentTypes.insert(componentType)
            }
        }

        // Assert all components in entityComponentMap appear in at most one componentMap key
        var componentIDs = Set<ComponentID>()
        for (_, components) in entityComponentMap {
            for component in components {
                let componentID = component.id
                assert(!componentIDs.contains(componentID),
                       "Error: Component \(componentID) appears in multiple entityComponentMap entries")
                componentIDs.insert(componentID)
            }
        }
    }
}
