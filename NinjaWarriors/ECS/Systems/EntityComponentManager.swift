//
//  EntityComponentManager.swift
//  NinjaWarriors
//
//  Created by Jivesh Mohan on 17/3/24.
//

import Foundation

// TODO: TBC
//@MainActor
class EntityComponentManager {
    var entityComponentMap: [EntityID: Set<Component>]
    var entityMap: [EntityID: Entity]
    var componentMap: [ComponentType: Set<Component>]

    var newEntityComponentMap: [EntityID: [Component]] = [:]
    var newEntity: [Entity] = []
    var newEntityMap: [EntityID: Entity] = [:]
    var newComponentMap: [ComponentType: Set<Component>] = [:]

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
    }

    deinit {
        stopListening()
    }

    func startListening() {
        print("start listening")
        manager.addEntitiesListener { snapshot in
            print("snap shot received")
            DispatchQueue.main.async {
                self.populate()
            }
        }
    }

    func stopListening() {
        manager.removeEntitiesListener()
    }

    func initialPopulate() {
        Task {
            //newEntityMap: [EntityID: Entity] = [:]
            (newEntity, newEntityComponentMap) = try await manager.getEntitiesWithComponents()

            /*
            for entity in newEntity {
                newEntityMap[entity.id] = entity
            }
            */
            for entity in newEntity {
                print("entity", entity)
            }
            ///*
            for (entityId, components) in newEntityComponentMap {
                for component in components {
                    newEntityMap[entityId] = component.entity
                }
            }
            //*/

            addEntitiesFromNewMap(newEntityMap, newEntityComponentMap)
            startListening()
        }
    }

    func populate() {
        print("populate executed")
        Task {
            //newEntityMap: [EntityID: Entity] = [:]
            (newEntity, newEntityComponentMap) = try await manager.getEntitiesWithComponents()

            for entity in newEntity {
                newEntityMap[entity.id] = entity
            }

            addEntitiesFromNewMap(newEntityMap, newEntityComponentMap)
            startListening()
        }
    }

    func addEntitiesFromNewMap(_ newEntityMap: [EntityID: Entity],
                               _ newEntityComponentMap: [EntityID: [Component]]) {
        for (newEntityId, newEntity) in newEntityMap {
            if let newComponents = newEntityComponentMap[newEntityId] {
                add(entity: newEntity, components: newComponents)
            } else {
                add(entity: newEntity)
            }
        }
    }

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

        var dstEntity: Entity
        if let originalEntity = entityMap[entity.id] {
            dstEntity = originalEntity
        } else {
            entityMap[entity.id] = entity
            dstEntity = entity
        }

        if entityComponentMap[entity.id] == nil {
            entityComponentMap[entity.id] = []
        }

        // Insert intializing components of entity
        let newComponents = entity.getInitializingComponents()
        //print("[EntityComponentManager] new", newComponents)
        newComponents.forEach({add(component: $0, to: dstEntity, srcEntity: entity)})

        //print("[EntityComponentManager] entityMap", entityMap)
        //print("[EntityComponentManager] entityComponentMap", entityComponentMap)

        if !isAdded {
            Task {
                // TODO: TBC on adding entity instead of dstEntity
                try await manager.uploadEntity(entity: entity, components: newComponents)
            }
        }
        assertRepresentation()
    }

    func add(entity: Entity, components: [Component], isAdded: Bool = true) {
        assertRepresentation()
        //print("[EntityComponentManager] add", entity)

        // TODO: TBC
        var dstEntity: Entity
        if let originalEntity = entityMap[entity.id] {
            dstEntity = originalEntity
        } else {
            entityMap[entity.id] = entity
            dstEntity = entity
        }

        if entityComponentMap[entity.id] == nil {
            entityComponentMap[entity.id] = []
        }

        // Insert intializing components of entity
        let newComponents = components
        //print("[EntityComponentManager] new", newComponents)
        newComponents.forEach({add(component: $0, to: dstEntity, srcEntity: entity)})

        //print("[EntityComponentManager] entityMap", entityMap)
        //print("[EntityComponentManager] entityComponentMap", entityComponentMap)

        if !isAdded {
            Task {
                // TODO: TBC on adding entity instead of dstEntity
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

    // New add by updating attributes
    private func add(component: Component, to entity: Entity, srcEntity: Entity, isAdded: Bool = true) {
        assertRepresentation()

        guard entityMap[entity.id] != nil else {
            assertionFailure("Entity not found")
            return
        }

        //component.entity = entity

        // This is causing some issue
        //print("component entity reference check", component.entity, entity)

        if let entity = entity as AnyObject?, let componentEntity = component.entity as AnyObject? {
            let entityId = ObjectIdentifier(entity)
            let componentEntityId = ObjectIdentifier(componentEntity)
            print("Component entity reference check:", entityId, componentEntityId)
        } else {
            print("One or both entities are nil")
        }

        //addComponentToMap(component, ofType: ComponentType(type(of: component)))
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
                print("update existing component attributes")
                existingComponent.updateAttributes(component)
                foundMatchingID = true
                break
            }
        }

        if !foundMatchingID {
            print("insert new components")
            componentMap[componentType, default: Set<Component>()].insert(component)
        }
    }

    private func addComponentToEntityMap(_ component: Component, for entity: Entity) {
        if var entityComponents = entityComponentMap[entity.id] {
            var foundMatchingComponent = false

            for existingComponent in entityComponents {
                if ComponentType(type(of: existingComponent)) == ComponentType(type(of: component)) {
                    existingComponent.updateAttributes(component)
                    foundMatchingComponent = true
                    break
                }
            }

            if !foundMatchingComponent {
                print("insert new components")
                entityComponents.insert(component)
                componentMap[ComponentType(type(of: component)), default: Set<Component>()].insert(component)
            }
            // TODO: TBC if it is needed
            entityComponentMap[entity.id] = entityComponents
        } else {
            print("insert new entity with new component")
            var newEntityComponents = Set<Component>()
            newEntityComponents.insert(component)
            entityComponentMap[entity.id] = newEntityComponents
            componentMap[ComponentType(type(of: component)), default: Set<Component>()].insert(component)
        }
    }

    private func uploadEntityToManager(_ entity: Entity, with component: Component) {
        Task {
            try await manager.uploadEntity(entity: entity, components: [component])
        }
    }

    func getComponent<T: Component>(ofType: T.Type, for entity: Entity) -> T? {
        let queue = DispatchQueue(label: "entityComponentQueue")

        var result: T?

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

// TODO: Not in use anymore. To be deprecated
extension EntityComponentManager {
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
}
