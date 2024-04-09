//
//  RealTimeManagerAdapter.swift
//  NinjaWarriors
//
//  Created by Muhammad Reyaaz on 18/3/24.
//

import Foundation
import FirebaseDatabase

final class RealTimeManagerAdapter: EntitiesManager {
    private let databaseRef = Database.database().reference()
    private var entitiesRef: DatabaseReference
    private let matchId: String
    private let componentKey = "component"
    private var listenerHandle: DatabaseHandle?

    init(matchId: String) {
        self.matchId = matchId
        entitiesRef = databaseRef.child(matchId)
    }

    func getEntitiesRef() -> DatabaseReference {
        entitiesRef
    }

    // MARK: Decode / Retrieve
    private func getEntityTypes(from entitiesDict: [String: [String: Any]]) -> [String] {
        return Array(entitiesDict.keys)
    }

    private func getIds(of type: String, from entitiesDict: [String: [String: Any]]) -> [String] {
        guard let entitiesData = entitiesDict[type] else {
            return []
        }
        return Array(entitiesData.keys)
    }

    private func getComponentTypes(from idDict: [String: Any]) -> [String]? {
        /*
        print("get component types")
        guard let componentDict = idDict[componentKey] else {
            print("return nil")
            return nil
        }
        print("not return nil", Array(componentDict.keys))
        */
        return Array(idDict.keys)
    }

    private func getDict(from ref: DatabaseReference) async throws -> [String: [String: Any]] {
        let dataSnapshot = try await ref.getData()
        guard let dict = dataSnapshot.value as? [String: [String: Any]] else {
            throw NSError(domain: "Invalid data format", code: -1, userInfo: nil)
        }
        return dict
    }

    private func getEntititesDict() async throws -> [String: [String: Any]] {
        let dataSnapshot = try await entitiesRef.getData()
        guard let entitiesDict = dataSnapshot.value as? [String: [String: Any]] else {
            throw NSError(domain: "Invalid entity data format", code: -1, userInfo: nil)
        }
        return entitiesDict
    }

    // TODO: Abstract out to type registry
    private func getComponentWrapperType(of type: String) -> Codable.Type? {
        let wrapperTypes: [String: Codable.Type] = [
            "SkillCasterWrapper": SkillCasterWrapper.self,
            "SpriteWrapper": SpriteWrapper.self,
            "HealthWrapper": HealthWrapper.self,
            "ColliderWrapper": ColliderWrapper.self,
            "ScoreWrapper": ScoreWrapper.self,
            "RigidbodyWrapper": RigidbodyWrapper.self
        ]

        let wrapperTypeName = "\(type)" + Constants.wrapperName
        guard let wrapperType = wrapperTypes[wrapperTypeName] else {
            print("return nil")
            return nil
        }
        return wrapperType
    }

    private func getWrapperType(of type: String) -> Codable.Type? {
        let wrapperTypeName = "\(type)" + Constants.wrapperName
        guard let wrapperType = NSClassFromString(Constants.directory + wrapperTypeName) as? Codable.Type else {
            return nil
        }
        return wrapperType
    }

    private func getWrapperType(from id: EntityID) async throws -> String? {
        let (_, wrapperType) = try await decodeEntities(id: id)
        return wrapperType
    }

    private func getEntity(from dict: Any, with wrapper: Codable.Type) throws -> Entity? {
        let entityData = try JSONSerialization.data(withJSONObject: dict, options: [])
        guard let entityWrapper: EntityWrapper = try JSONDecoder().decode(wrapper,
                                                                         from: entityData) as? EntityWrapper else {
            return nil
        }
        guard let entity = entityWrapper.toEntity() else {
            return nil
        }
        return entity
    }

    private func decodeEntities(id: EntityID? = nil) async throws -> ([Entity]?, String?) {
        var entities: [Entity] = []
        let entitiesDict = try await getEntititesDict()
        let entityTypes = getEntityTypes(from: entitiesDict)

        for entityType in entityTypes {
            guard let wrapperType = getWrapperType(of: entityType) else {
                return (nil, nil)
            }
            let entityIds = getIds(of: entityType, from: entitiesDict)

            for entityId in entityIds {
                if id != nil && entityId != id {
                    continue
                }
                guard let dataDict = entitiesDict[entityType]?[entityId],
                      let entity = try getEntity(from: dataDict, with: wrapperType) else {
                    return (nil, nil)
                }
                entities.append(entity)
                if id != nil && entityId == id {
                    return (entities, entityType)
                }
            }
        }
        return (entities, nil)
    }

    func getAllEntities() async throws -> [Entity]? {
        let (entities, _) = try await decodeEntities()
        return entities
    }

    func getEntity(entityId: EntityID) async throws -> Entity? {
        let (entities, _) = try await decodeEntities(id: entityId)
        guard let entities = entities else {
            return nil
        }
        return entities[0]
    }

    /*
    private func getComponent(from dict: Any, with wrapper: Codable.Type) throws -> Component? {
        let componentData = try JSONSerialization.data(withJSONObject: dict, options: [])
        guard let componentWrapper: ComponentWrapper = try JSONDecoder().decode(wrapper,
                                                                         from: componentData) as? ComponentWrapper else {
            print("returning nil 1")
            return nil
        }
        guard let component = componentWrapper.toComponent() else {
            print("returning nil 2", wrapper)
            return nil
        }
        return component
    }
    */

    private func getComponent(from dict: Any, with wrapper: Codable.Type) -> Component? {
        do {
            print("dict", dict)
            let componentData = try JSONSerialization.data(withJSONObject: dict, options: [])
            guard let componentWrapper: ComponentWrapper = try JSONDecoder().decode(wrapper, from: componentData) as? ComponentWrapper else {
                print("Error: Failed to decode component wrapper")
                return nil
            }
            guard let component = componentWrapper.toComponent() else {
                print("Error: Failed to convert wrapper to component")
                return nil
            }
            return component
        } catch {
            print("Error: \(error)")
            return nil
        }
    }

    /*
    func getEntitiesWithComponents() async throws -> [EntityID: [Component]] {
        var entityComponent: [EntityID: [Component]] = [:]
        let entitiesDict = try await getEntititesDict()
        let entityTypes = getEntityTypes(from: entitiesDict)

        for entityType in entityTypes {
            let entityIds = getIds(of: entityType, from: entitiesDict)
            for entityId in entityIds {
                guard let test = entitiesDict[entityType]?[entityId] as? [String: Any] else {
                    print("guard return")
                    return [:]
                }
                guard let idData = test[componentKey] as? [String: Any],
                      let componentTypes = getComponentTypes(from: idData) else {
                    print("guard return 2")
                    return [:]
                }
                var componentCount = componentTypes.count
                for componentType in componentTypes {
                    componentCount -= 1
                    guard let componentWrapper = getComponentWrapperType(of: componentType),
                          let componentDict = idData[componentType],
                          let component = try getComponent(from: componentDict, with: componentWrapper) else {
                        print("continue guard")
                        continue
                    }
                    if entityComponent[entityId] == nil {
                        entityComponent[entityId] = [component]
                    } else {
                        entityComponent[entityId]?.append(component)
                    }
                    print("end of loop", componentCount)
                }
                print("outside loop")
                print("old entity component", entityComponent)
            }
        }
        return entityComponent
    }
    */

    func getEntitiesWithComponents() async throws -> [EntityID: [Component]] {
        var entityComponent: [EntityID: [Component]] = [:]
        let entitiesDict = try await getEntititesDict()
        let entityTypes = getEntityTypes(from: entitiesDict)

        for entityType in entityTypes {
            print("entity type", entityType)
            try processEntities(for: entityType, withEntities: entitiesDict, into: &entityComponent)
        }
        return entityComponent
    }

    private func processEntities(for entityType: String,
                                 withEntities entitiesDict: [String: [String: Any]],
                                 into entityComponent: inout [EntityID: [Component]]) throws {
        let entityIds = getIds(of: entityType, from: entitiesDict)

        for entityId in entityIds {
            print("entity id", entityId)
            guard let test = entitiesDict[entityType]?[entityId] as? [String: Any] else {
                print("guard return")
                return
            }

            //print("testing", test[componentKey] as? [String: Any])
            //print("testing", entitiesDict[entityType]?[entityId] as? [String: [String: Any]])

            /*
            guard let idData = entitiesDict[entityType]?[entityId] as? [String: [String: Any]],
                  let componentTypes = getComponentTypes(from: idData) else {
                return
            }
            */
            guard let idData = test[componentKey] as? [String: Any],
                  let componentTypes = getComponentTypes(from: idData) else {
                print("guard return 2")
                return
            }
            try processComponents(for: entityId, withComponentTypes: componentTypes, from: idData, into: &entityComponent)
        }
    }

    private func processComponents(for entityId: EntityID, withComponentTypes componentTypes: [String],
                                   from idData: [String: Any],
                                   into entityComponent: inout [EntityID: [Component]]) throws {
        var componentCount = componentTypes.count
        for componentType in componentTypes {
            print("component type", componentType)
            componentCount -= 1
            guard let componentWrapper = getComponentWrapperType(of: componentType),
                  let componentDict = idData[componentType],
                  let component = try getComponent(from: componentDict, with: componentWrapper) else {
                print("continue guard")
                //print("continue 1", componentType, getWrapperType(of: componentType), idData[componentType])
                continue
            }
            print("outside continue guard")
            if entityComponent[entityId] == nil {
                entityComponent[entityId] = [component]
            } else {
                entityComponent[entityId]?.append(component)
            }
            print("end of loop", componentCount)
        }
        print("outside loop")
        print("old entity component", entityComponent)
    }


    // MARK: Encode / Upload
    private func formEntityDict(from entity: Entity) throws -> [String: Any] {
        let entityData = try JSONEncoder().encode(entity.wrapper())

        guard let entityDict = try JSONSerialization.jsonObject(with: entityData, options: []) as? [String: Any] else {
            throw NSError(domain: "com.yourapp", code: -1,
                          userInfo: [NSLocalizedDescriptionKey: "Failed to serialize player data"])
        }
        return entityDict
    }

    private func formComponentDict(from components: [Component]) -> [String: Any] {
        var componentDict: [String: Any] = [:]

        for (index, component) in components.enumerated() {
            let key = NSStringFromClass(type(of: component))
                .components(separatedBy: ".").last ?? componentKey + "\(index)"

            guard let data = component.wrapper(),
                  let componentData = try? JSONEncoder().encode(data),
                  let dataDict = try? JSONSerialization.jsonObject(with: componentData,
                                                                   options: []) as? [String: Any] else {
                continue
            }
            componentDict[key] = dataDict
        }
        return componentDict
    }

    func uploadEntity(entity: Entity, components: [Component]? = nil) async throws {
        let entityName = NSStringFromClass(type(of: entity))
            .components(separatedBy: ".").last ?? "entity"

        let entityRef = entitiesRef.child(entityName).child(entity.id)

        entityRef.observeSingleEvent(of: .value) { [weak self] snapshot in
            guard let self = self else { return }

            if snapshot.exists() {
                self.updateExistingEntity(snapshot, entityRef, entity, components)
            } else {
                self.createEntity(snapshot, entityRef, entity)
            }
        }
    }

    private func updateExistingEntity(_ snapshot: DataSnapshot, _ entityRef: DatabaseReference,
                              _ entity: Entity, _ components: [Component]?) {
        guard var entityDict = snapshot.value as? [String: Any] else {
            print("Data at \(entityRef) is not in the expected format")
            return
        }

        guard let components = components else {
            return
        }

        // Case 1a: If componentKey exists, merge newComponentDict with existingComponentDict
        if entityDict[self.componentKey] is [String: Any] {
            updateExistingComponents(&entityDict, components)
        // Case 1b: If componentKey doesn't exist, append newComponentDict
        } else {
            appendNewComponents(&entityDict, components)
        }

        entityRef.setValue(entityDict)
    }

    private func updateExistingComponents(_ entityDict: inout [String: Any], _ components: [Component]) {
        guard var existingComponentDict = entityDict[componentKey] as? [String: Any] else { return }

        let newComponentDict = formComponentDict(from: components)
        existingComponentDict.merge(newComponentDict) { (_, new) in new }
        entityDict[componentKey] = existingComponentDict
    }

    private func appendNewComponents(_ entityDict: inout [String: Any], _ components: [Component]) {
        let newComponentDict = formComponentDict(from: components)
        entityDict[componentKey] = newComponentDict
    }

    private func createEntity(_ snapshot: DataSnapshot, _ entityRef: DatabaseReference, _ entity: Entity) {
        var newEntityDict: [String: Any] = [:]

        if let entityDict = try? formEntityDict(from: entity) {
            newEntityDict.merge(entityDict) { (_, new) in new }
        }

        let initializingComponents = entity.getInitializingComponents()
        let initialComponentDict = formComponentDict(from: initializingComponents)
        newEntityDict[componentKey] = initialComponentDict

        entityRef.setValue(newEntityDict)
    }

    // MARK: Delete
    func delete(entity: Entity) {
        let entityName = NSStringFromClass(type(of: entity))
            .components(separatedBy: ".").last ?? "entity"

        let entityId = entity.id

        let entityRef = entitiesRef.child(entityName).child(entityId)
        entityRef.removeValue { error, _ in
            if let error = error {
                print("Error deleting entity: \(error)")
            } else {
                print("Entity deleted successfully")
            }
        }
    }

    func delete(component: Component, from entity: Entity) {
        let entityName = NSStringFromClass(type(of: entity))
            .components(separatedBy: ".").last ?? "entity"

        let componentName = NSStringFromClass(type(of: component))
            .components(separatedBy: ".").last ?? "component"

        let entityId = entity.id

        let entityRef = entitiesRef.child(entityName).child(entityId)
            .child(componentKey).child(componentName)

        entityRef.removeValue { error, _ in
            if let error = error {
                print("Error deleting component: \(error)")
            } else {
                print("Entity deleted successfully")
            }
        }
    }

    func delete() {
        entitiesRef.removeValue { error, _ in
            if let error = error {
                print("Error deleting match data: \(error)")
            } else {
                print("Entity deleted successfully")
            }
        }
    }

    private func deleteAllKeysExcept(matchId: String) {
        let ref = Database.database().reference()
        ref.observeSingleEvent(of: .value) { snapshot in
            guard snapshot.exists() else {
                return
            }

            let enumerator = snapshot.children
            while let rest = enumerator.nextObject() as? DataSnapshot {
                let key = rest.key
                if key != matchId {
                    ref.child(key).removeValue()
                }
            }
        }
    }

    // MARK: Listeners
    func addEntitiesListener(completion: @escaping (DataSnapshot) -> Void) {
        removeEntitiesListener()
        listenerHandle = entitiesRef.observe(.value) { snapshot in
            completion(snapshot)
        }
    }

    func removeEntitiesListener() {
        if let handle = listenerHandle {
            entitiesRef.removeObserver(withHandle: handle)
        }
        listenerHandle = nil
    }

    func addPlayerListeners() -> [PlayerPublisher] {
        var listenerPublishers: [PlayerPublisher] = []
        let playersListener = PlayersListener(matchId: matchId)
        playersListener.startListening()

        listenerPublishers.append(playersListener.getPublisher())
        return listenerPublishers
    }
}
