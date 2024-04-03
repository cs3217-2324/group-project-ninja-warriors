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

    var id: String

    var manager: EntitiesManager

    var components: [Component] {
        var allComponents: [Component] = []
        for (_, componentArray) in componentMap {
            allComponents.append(contentsOf: componentArray)
        }
        return allComponents
    }

    init(for match: String, id: String) {
        entityComponentMap = [:]
        entityMap = [:]
        componentMap = [:]
        manager = RealTimeManagerAdapter(matchId: match)
        self.id = id

        self.startListening()
    }

    func populate() {
        Task { [unowned self] in
            if let entities = try await self.manager.getAllEntities() {
                for entity in entities {
                    add(entity: entity)
                }
                self.startListening()
            }
        }
    }

    func startListening() {
        print("start listening")
        manager.addEntitiesListener { snapshot in

            print(self.id)

            //print("snapshot received")
            //print("Snapshot received: \(snapshot)")
            Task { [unowned self] in
                //try await self.repopulate()
            }
        }
    }

    func stopListening() {
        manager.removeEntitiesListener()
    }

    func repopulate() async throws {
        print("repopulate")
        var newEntityMap: [EntityID: Entity] = [:]
        let newEntityComponentMap = try await manager.getEntitiesWithComponents()
        print("new entity component map", newEntityComponentMap)

        for newEntityID in newEntityComponentMap.keys {
            newEntityMap[newEntityID] = try await manager.getEntity(entityId: newEntityID)
        }

        for (newEntityId, newEntity) in newEntityMap {
            var newComponents: [Component]

            if let newEntityComponents = newEntityComponentMap[newEntityId] {
                newComponents = newEntityComponents
                add(entity: newEntity, components: newComponents)
            } else {
                add(entity: newEntity)
            }
        }
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

    func add(entity: Entity, isAdded: Bool = true) {
        assertRepresentation()
        print("[EntityComponentManager] add", entity)
        entityMap[entity.id] = entity
        entityComponentMap[entity.id] = []

        // Insert intializing components of entity
        let newComponents = entity.getInitializingComponents()
        print("[EntityComponentManager] new", newComponents)
        newComponents.forEach({add(component: $0, to: entity)})

        print("[EntityComponentManager] entityMap", entityMap)
        print("[EntityComponentManager] entityComponentMap", entityComponentMap)

        if !isAdded {
            Task {
                try await manager.uploadEntity(entity: entity, components: newComponents)
            }
        }
        assertRepresentation()
    }

    func add(entity: Entity, components: [Component], isAdded: Bool = true) {
        assertRepresentation()
        print("[EntityComponentManager] add", entity)
        entityMap[entity.id] = entity
        entityComponentMap[entity.id] = []

        // Insert intializing components of entity
        let newComponents = components
        print("[EntityComponentManager] new", newComponents)
        newComponents.forEach({add(component: $0, to: entity)})

        print("[EntityComponentManager] entityMap", entityMap)
        print("[EntityComponentManager] entityComponentMap", entityComponentMap)

        if !isAdded {
            Task {
                try await manager.uploadEntity(entity: entity, components: newComponents)
            }
        }
        assertRepresentation()
    }

    func remove(entity: Entity, isRemoved: Bool = true) {
        assertRepresentation()

        removeComponents(from: entity)
        entityMap[entity.id] = nil
        entityComponentMap[entity.id] = nil

        if !isRemoved {
            manager.delete(entity: entity)
        }
        assertRepresentation()
    }

    func getEntityId(from component: Component) -> EntityID? {
        for (entityID, components) in entityComponentMap {
            if components.contains(component) {
                return entityID
            }
        }
        return nil
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

    private func add(component: Component, to entity: Entity, isAdded: Bool = true) {
        assertRepresentation()

        guard entityMap[entity.id] != nil else {
            assertionFailure("Entity not found")
            return
        }
        component.entity = entity

        let componentType = ComponentType(type(of: component))
        componentMap[componentType, default: Set<Component>()].insert(component)
        entityComponentMap[entity.id]?.insert(component)

        if !isAdded {
            Task {
                try await manager.uploadEntity(entity: entity, components: [component])
            }
        }
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

    private func remove(component: Component, from entity: Entity, isRemoved: Bool = true) {
        guard entityMap[entity.id] != nil && entityComponentMap[entity.id] != nil else {
            assertionFailure("Entity not found in removeComponent call")
            return
        }
        entityComponentMap[entity.id]?.remove(component)
        componentMap[ComponentType(type(of: component))]?.remove(component)

        if !isRemoved {
            manager.delete(component: component, from: entity)
        }
    }

    private func removeComponents(from entity: Entity, isRemoved: Bool = true) {
        let entityID = entity.id
        if let componentsToRemove = entityComponentMap[entityID] {
            for component in componentsToRemove {
                let componentType = type(of: component)

                componentMap[ComponentType(componentType)]?.remove(component)

                if !isRemoved {
                    manager.delete(component: component, from: entity)
                }
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

    func reset(isRemoved: Bool = true) {
        entityComponentMap = [:]
        entityMap = [:]
        componentMap = [:]

        if !isRemoved {
            manager.delete()
        }
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
