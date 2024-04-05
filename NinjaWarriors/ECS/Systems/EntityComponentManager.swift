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

    var manager: EntitiesManager

    var components: [Component] {
        var allComponents: [Component] = []
        for (_, componentArray) in componentMap {
            allComponents.append(contentsOf: componentArray)
        }
        return allComponents
    }

    init(for match: String) {
        entityComponentMap = [:]
        entityMap = [:]
        componentMap = [:]
        manager = RealTimeManagerAdapter(matchId: match)

        //startListening()
    }

    deinit {
        stopListening()
    }

    func startListening() {
        //print("start listening")
        manager.addEntitiesListener { snapshot in
            //print("snap shot received")
            DispatchQueue.main.async {
                        self.populate()
                    }
            /*
            Task { [unowned self] in
                self.populate()
            }
            */
        }
    }

    func stopListening() {
        manager.removeEntitiesListener()
    }

    // Fetches from realtime and populates the ecm
    func initialPopulate() {
        Task {
            var newEntityMap: [EntityID: Entity] = [:]
            let newEntityComponentMap = try await manager.getEntitiesWithComponents()

            for newEntityID in newEntityComponentMap.keys {
                newEntityMap[newEntityID] = try await manager.getEntity(entityId: newEntityID)
            }
            addEntitiesFromNewMap(newEntityMap, newEntityComponentMap)

            //remapAttachCollider()
            //remapColliderRigidbody()
            startListening()
        }
    }

    func populate() {
        Task {
            var newEntityMap: [EntityID: Entity] = [:]
            let newEntityComponentMap = try await manager.getEntitiesWithComponents()

            for newEntityID in newEntityComponentMap.keys {
                newEntityMap[newEntityID] = try await manager.getEntity(entityId: newEntityID)
            }
            addEntitiesFromNewMap(newEntityMap, newEntityComponentMap)

            /*
            remapAttachCollider()
            remapColliderRigidbody()
            remapCollider()

            remapAttachCollider()
            remapColliderRigidbody()
            remapCollider()
            */
        }
    }

    func addEntitiesFromNewMap(_ newEntityMap: [EntityID: Entity],
                               _ newEntityComponentMap: [EntityID: [Component]]) {
        for (newEntityId, newEntity) in newEntityMap {
            // If entity exists, use original (old) entity memory reference


            /*
            if let oldEntity = entityMap[newEntityId] {
                print("if")
                if let newComponents = newEntityComponentMap[newEntityId] {
                    add(entity: oldEntity, components: newComponents)
                } else {
                    add(entity: oldEntity)
                }
            // If entity doesn't exist, use new entity memory reference
            } else {
                if let newComponents = newEntityComponentMap[newEntityId] {
                    add(entity: newEntity, components: newComponents)
                } else {
                    add(entity: newEntity)
                }
            }
            */

            if let newComponents = newEntityComponentMap[newEntityId] {
                add(entity: newEntity, components: newComponents)
            } else {
                add(entity: newEntity)
            }


        }
    }

    func remapAttachCollider() {
        for (entityId, _) in entityMap {
            guard let components = entityComponentMap[entityId] else {
                continue
            }
            for component in components {
                if let componentToUpload = component as? Rigidbody {
                    if let componentCollider = componentToUpload.attachedCollider {
                        componentCollider.entity = componentToUpload.entity
                    } else {
                        print("no attached collider")
                    }
                }
            }
        }
    }

    func remapColliderRigidbody() {
        let colliders = getAllComponents(ofType: Collider.self)

        let rigidBodies = getAllComponents(ofType: Rigidbody.self)

        for collider in colliders {
            if let matchingRigidBody = rigidBodies.first(where: { $0.entity.id == collider.entity.id }) {
                matchingRigidBody.attachedCollider = collider
                //print("Attached collider to rigid body with entity ID:", matchingRigidBody.entity.id)
            }
        }
    }


    func remapCollider() {
        let colliders = getAllComponents(ofType: Collider.self)

        let rigidBodies = getAllComponents(ofType: Rigidbody.self)

        for collider in colliders {
            if let matchingRigidBody = rigidBodies.first(where: { $0.entity.id == collider.entity.id }) {
                collider.entity = matchingRigidBody.entity
                //print("Attached collider to rigid body with entity ID:", matchingRigidBody.entity.id)
            }
        }
    }

    /*
    func remapCollider() {
        let colliders = getAllComponents(ofType: Collider.self)

        for collider in colliders {
            if let entity = entityMap[collider.entity.id] {
                collider.entity = entity
            }
        }
    }
    */

    func publish () async throws {
        for (entityId, entity) in entityMap {
            guard let components = entityComponentMap[entityId] else {
                continue
            }
            try await manager.uploadEntity(entity: entity, components: Array(components))
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
        //print("[EntityComponentManager] add", entity)
        entityMap[entity.id] = entity

        if entityComponentMap[entity.id] == nil {
            entityComponentMap[entity.id] = []
        }

        // Insert intializing components of entity
        let newComponents = entity.getInitializingComponents()
        //print("[EntityComponentManager] new", newComponents)
        newComponents.forEach({add(component: $0, to: entity)})

        //print("[EntityComponentManager] entityMap", entityMap)
        //print("[EntityComponentManager] entityComponentMap", entityComponentMap)

        if !isAdded {
            Task {
                try await manager.uploadEntity(entity: entity, components: newComponents)
            }
        }
        assertRepresentation()
    }

    func add(entity: Entity, components: [Component], isAdded: Bool = true) {
        assertRepresentation()
        //print("[EntityComponentManager] add", entity)
        entityMap[entity.id] = entity

        if entityComponentMap[entity.id] == nil {
            entityComponentMap[entity.id] = []
        }

        // Insert intializing components of entity
        let newComponents = components
        //print("[EntityComponentManager] new", newComponents)
        newComponents.forEach({add(component: $0, to: entity)})

        //print("[EntityComponentManager] entityMap", entityMap)
        //print("[EntityComponentManager] entityComponentMap", entityComponentMap)

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



    /*
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

        //print("after add to:", entity.id, entityComponentMap)

        if !isAdded {
            Task {
                try await manager.uploadEntity(entity: entity, components: [component])
            }
        }
        assertRepresentation()
    }
    */

    private func add(component: Component, to entity: Entity, isAdded: Bool = true) {
        assertRepresentation()

        guard entityMap[entity.id] != nil else {
            assertionFailure("Entity not found")
            return
        }

        // This is causing the issue
        component.entity = entity

        addComponentToMap(component, ofType: ComponentType(type(of: component)))
        addComponentToEntityMap(component, for: entity)

        if !isAdded {
            uploadEntityToManager(entity, with: component)
        }

        assertRepresentation()
    }

    private func addComponentToMap(_ component: Component, ofType componentType: ComponentType) {
        let existingComponents = componentMap[componentType, default: Set<Component>()]
        var foundMatchingID = false

        for existingComponent in existingComponents {
            if existingComponent.id == component.id {
                // Update existing component's attributes
                existingComponent.updateAttributes(component)
                foundMatchingID = true
                break
            }
        }

        if !foundMatchingID {
            componentMap[componentType, default: Set<Component>()].insert(component)
        }
    }

    private func addComponentToEntityMap(_ component: Component, for entity: Entity) {
        if var entityComponents = entityComponentMap[entity.id] {
            var foundMatchingID = false

            for existingComponent in entityComponents {
                if existingComponent.id == component.id {
                    // Update existing component's attributes
                    existingComponent.updateAttributes(component)
                    foundMatchingID = true
                    break
                }
            }

            if !foundMatchingID {
                entityComponents.insert(component)
            }
            entityComponentMap[entity.id] = entityComponents
        } else {
            var newEntityComponents = Set<Component>()
            newEntityComponents.insert(component)
            entityComponentMap[entity.id] = newEntityComponents
        }
    }

    private func uploadEntityToManager(_ entity: Entity, with component: Component) {
        Task {
            try await manager.uploadEntity(entity: entity, components: [component])
        }
    }

    /*
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
    */

    ///*
    func getComponent<T: Component>(ofType: T.Type, for entity: Entity) -> T? {
        let queue = DispatchQueue(label: "com.example.entityComponentQueue")

        var result: T?

        print("entity id", entity.id)
        queue.sync {
            guard let entityComponents = entityComponentMap[entity.id] else {
                return
            }

            let components = entityComponents.filter({$0 is T})

            assert(components.count <= 1, "Entity has multiple components of the same type")

            if let component = components.first as? T {
                result = component
            }
        }
        return result
    }
    //*/

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
