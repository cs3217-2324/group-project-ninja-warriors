//
//  EntityComponentManager.swift
//  NinjaWarriors
//
//  Created by Jivesh Mohan on 17/3/24.
//

import Foundation

class EntityComponentManager {
    // To store local entity component data
    var entityComponentMap: [EntityID: Set<Component>]
    var entityMap: [EntityID: Entity]
    var componentMap: [ComponentType: Set<Component>]

    // To store entity component data fetched from database
    var newEntityComponentMap: [EntityID: [Component]] = [:]
    var newEntity: [Entity] = []
    var newEntityMap: [EntityID: Entity] = [:]
    var newComponentMap: [ComponentType: Set<Component>] = [:]

    // To only publish own entities
    var ownEntities: Set<EntityID> = []

    private var mapQueue = EventQueue(label: "entityComponentMapQueue")
    private var newMapQueue = EventQueue(label: "newEntityComponentMapQueue")

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

    // No mapQueue needed for intial population
    func initialPopulate() {
        Task {
            (newEntity, newEntityComponentMap) = try await manager.getEntitiesWithComponents()
            DispatchQueue.main.sync { [self] in
                for (entityId, components) in newEntityComponentMap {
                    for component in components {
                        newEntityMap[entityId] = component.entity
                    }
                }
            }
            addEntitiesFromNewMap(newEntityMap, newEntityComponentMap)
        }
    }

    func intialPopulateWithCompletion(completion: @escaping () -> Void) {
        Task {
            do {
                // newEntity is needed due to unowned reference although a warning is shown
                let (newEntity, newEntityComponentMap) = try await manager.getEntitiesWithComponents()
                for (entityId, components) in newEntityComponentMap {
                    for component in components {
                        newEntityMap[entityId] = component.entity
                    }
                }
                addEntitiesFromNewMap(newEntityMap, newEntityComponentMap)
                completion()
            } catch {
                print("Error: \(error)")
            }
        }
    }

    // Queue needed for subsequent population as it runs concurrently with publish
    func populate() async {
        do {
            let (remoteEntity, remoteEntityComponentMap) = try await manager.getEntitiesWithComponents()

            newMapQueue.sync {
                self.newEntityMap.removeAll()
                for entity in remoteEntity {
                    guard (entity as? ClosingZone) == nil,
                          (entity as? Obstacle) == nil
                    else {
                        continue
                    }
                    self.newEntityMap[entity.id] = entity
                }
            }
            Task {
                addEntitiesFromNewMap(newEntityMap, remoteEntityComponentMap)
            }
        } catch {
            print("Error fetching entities with components: \(error)")
        }
    }

    func addEntitiesFromNewMap(_ remoteEntityMap: [EntityID: Entity],
                                _ remoteEntityComponentMap: [EntityID: [Component]]) {
        DispatchQueue.main.async {
            for (remoteEntityId, remoteEntity) in remoteEntityMap {
                if let newComponents = remoteEntityComponentMap[remoteEntityId] {
                    self.add(entity: remoteEntity, components: newComponents)
                } else {
                    self.add(entity: remoteEntity)
                }
            }
        }
    }

    func publish() async throws {
        for (entityId, entity) in entityMap {
            guard (entity as? ClosingZone) == nil,
                  (entity as? Obstacle) == nil,
                  ownEntities.contains(entityId)
            else {
                continue
            }
            var entityComponents: Set<Component> = []
            DispatchQueue.main.sync {
            // mapQueue.sync {
                guard let components = self.entityComponentMap[entityId] else {
                    return
                }
                entityComponents = components
            }
            do {
                // Upload the entity with its components
                let filteredComponents = filterComponentsToPublish(Array(entityComponents))
                try await manager.uploadEntity(entity: entity, components: filteredComponents)
            } catch {
                // Handle errors during upload
                print("Error uploading entity with ID \(entityId): \(error)")
            }
        }
    }

    func filterComponentsToPublish(_ componentsToFilter: [Component]) -> [Component] {
        return componentsToFilter.filter { component in
            if let _ = component as? Health {
                return true
            } else {
                return ownEntities.contains { $0 == component.entity.id }
            }
        }
    }

    func addOwnEntity(_ entity: Entity) {
        ownEntities.insert(entity.id)
    }

    func addOwnEntities(_ entities: [Entity]) {
        for entity in entities {
            ownEntities.insert(entity.id)
        }
    }

    func removeOwnEntity(_ entity: Entity) {
        ownEntities = ownEntities.filter { $0 != entity.id }
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
        guard !mapQueue.contains(entity) else {
            return
        }
        assertRepresentation()

        let dstEntity = getDestinationEntity(for: entity)

        let newComponents = entity.getInitializingComponents()

        newComponents.forEach({add(component: $0, to: dstEntity, srcEntity: entity)})

        if !isAdded {
            Task {
                try await manager.uploadEntity(entity: entity, components: newComponents)
            }
        }
        assertRepresentation()
    }

    func add(entity: Entity, components: [Component], isAdded: Bool = true) {
        guard !mapQueue.contains(entity) else {
            return
        }
        assertRepresentation()

        let dstEntity = getDestinationEntity(for: entity)

        if entityComponentMap[entity.id] == nil {
            entityComponentMap[entity.id] = []
        }

        // Insert intializing components of entity
        let newComponents = components

        newComponents.forEach({add(component: $0, to: dstEntity, srcEntity: entity)})

        if !isAdded {
            Task {
                print("new components", newComponents)
                try await manager.uploadEntity(entity: entity, components: newComponents)
            }
        }
        assertRepresentation()
    }

    // Since component have unowned reference to entity, must always use existing entity
    private func getDestinationEntity(for entity: Entity) -> Entity {
        if let originalEntity = entityMap[entity.id] {
            return originalEntity
        } else {
            entityMap[entity.id] = entity
            return entity
        }
    }

    func remove(entity: Entity, isRemoved: Bool = true) {
        assertRepresentation()

        mapQueue.process(entity.id)

        // Remove components from both local ecm and fetched ecm
        removeComponents(from: entity, isRemoved: isRemoved)

        // Remove entity id from both local ecm and fetched ecm
        entityMap[entity.id] = nil
        newEntityMap[entity.id] = nil

        entityComponentMap[entity.id] = nil
        newEntityComponentMap[entity.id] = nil

        // Remove entities
        newEntity = newEntity.filter {$0.id != entity.id}
        removeOwnEntity(entity)

        if !isRemoved {
            manager.delete(entity: entity)
        }

        assertRepresentation()
    }

    func getEntityId(from component: Component) -> EntityID? {
        self.mapQueue.sync {
            for (entityID, components) in entityComponentMap {
                if components.contains(component) {
                    return entityID
                }
            }
            return nil
        }
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
        addComponentToEntityMap(component, for: entity)

        if !isAdded {
            uploadEntityToManager(entity, with: component)
        }
        assertRepresentation()
    }

    private func addComponentToEntityMap(_ component: Component, for entity: Entity) {
        let componentType = ComponentType(type(of: component))
        var entityComponents = entityComponentMap[entity.id] ?? Set<Component>()

        if let existingComponent = findExistingComponent(ofType: componentType, in: entityComponents) {
            updateExistingComponent(existingComponent, with: component)
        } else {
            insertNewComponent(component, ofType: componentType, into: &entityComponents)
        }

        entityComponentMap[entity.id] = entityComponents
    }

    private func findExistingComponent(ofType checkType: ComponentType, in components: Set<Component>) -> Component? {
        return components.first(where: { ComponentType(type(of: $0)) == checkType })
    }

    private func updateExistingComponent(_ existingComponent: Component, with newComponent: Component) {
        let existingComponentType: ComponentType = ComponentType(type(of: existingComponent))
        guard existingComponentType == ComponentType(Rigidbody.self)
                || existingComponentType == ComponentType(Health.self)
                || existingComponentType == ComponentType(Collider.self)
                || existingComponentType == ComponentType(Dodge.self)
        else { return }
        existingComponent.updateAttributes(newComponent)
    }

    private func insertNewComponent(_ newComponent: Component, ofType type: ComponentType, into entityComponents: inout Set<Component>) {
        entityComponents.insert(newComponent)
        componentMap[type, default: Set<Component>()].insert(newComponent)
    }

    private func uploadEntityToManager(_ entity: Entity, with component: Component) {
        Task {
            try await manager.uploadEntity(entity: entity, components: [component])
        }
    }

    func getComponent<T: Component>(ofType type: T.Type, for entity: Entity) -> T? {
        var result: T?
        mapQueue.sync {
            guard let entityComponents = entityComponentMap[entity.id] else {
                return
            }
            for component in entityComponents {
                if let typedComponent = component as? T {
                    result = typedComponent
                    break
                }
            }
        }
        return result
    }

    func getAllComponents(for entity: Entity) -> [Component] {
        var result: [Component] = []
        mapQueue.sync {
            if let components = entityComponentMap[entity.id] {
                result = Array(components)
            }
        }

        return result
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
                newComponentMap[ComponentType(componentType)]?.remove(component)

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
        for deletedEntity in mapQueue.deletedEntities {
            entityMap[deletedEntity] = nil
        }
        return Array(entityMap.values)
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
