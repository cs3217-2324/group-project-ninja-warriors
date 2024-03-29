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

    init(matchId: String) {
        self.matchId = matchId
        entitiesRef = databaseRef.child(matchId)
    }

    private func getEntityTypes(from entitiesDict: [String: [String: Any]]) -> [String] {
        Array(entitiesDict.keys)
    }

    private func getIds(of type: String, from entitiesDict: [String: [String: Any]]) -> [String] {
        guard let entitiesData = entitiesDict[type] else {
            return []
        }
        return Array(entitiesData.keys)
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

    private func getWrapperType(of entityType: String) -> Codable.Type? {
        let wrapperTypeName = "\(entityType.capitalized)" + Constants.wrapperName
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
                      let entity = try getEntity(from: dataDict, with: wrapperType)else {
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

    // TODO: Take in an array of components instead
    func uploadEntity(entity: Entity, entityName: String, component: Component? = nil) async throws {
        let entityRef = entitiesRef.child(entityName).child(entity.id)

        entityRef.observeSingleEvent(of: .value) { [weak self] snapshot in
            guard let self = self else { return }

            if snapshot.exists() {
                self.updateExistingEntity(snapshot, entityRef, entity, component)
            } else {
                self.createEntity(snapshot, entityRef, entity, component)
            }
        }
    }

    func updateExistingEntity(_ snapshot: DataSnapshot, _ entityRef: DatabaseReference, _ entity: Entity, _ component: Component?) {
        guard var entityDict = snapshot.value as? [String: Any] else {
            print("Data at \(entityRef) is not in the expected format")
            return
        }

        guard let component = component else {
            return
        }

        // Case 1a: If componentKey exists, merge newComponentDict with existingComponentDict
        if entityDict[self.componentKey] is [String: Any] {
            updateExistingComponent(&entityDict, component)
        // Case 1b: If componentKey doesn't exist, append newComponentDict
        } else {
            appendNewComponent(&entityDict, component)
        }

        entityRef.setValue(entityDict)
    }

    func updateExistingComponent(_ entityDict: inout [String: Any], _ component: Component) {
        guard var existingComponentDict = entityDict[componentKey] as? [String: Any] else { return }
        let components = [component]
        let newComponentDict = formComponentDict(from: components)
        existingComponentDict.merge(newComponentDict) { (_, new) in new }
        entityDict[componentKey] = existingComponentDict
    }

    func appendNewComponent(_ entityDict: inout [String: Any], _ component: Component) {
        let components = [component]
        let newComponentDict = formComponentDict(from: components)
        entityDict[componentKey] = newComponentDict
    }

    func createEntity(_ snapshot: DataSnapshot, _ entityRef: DatabaseReference, _ entity: Entity, _ component: Component?) {
        var newEntityDict: [String: Any] = [:]

        if let entityDict = try? formEntityDict(from: entity) {
            newEntityDict.merge(entityDict) { (_, new) in new }
        }

        if let component = component {
            appendNewComponent(&newEntityDict, component)
        }

        let initializingComponents = entity.getInitializingComponents()
        let initialComponentDict = formComponentDict(from: initializingComponents)
        newEntityDict[componentKey] = initialComponentDict

        entityRef.setValue(newEntityDict)
    }

    // Function to delete all keys except the specified one
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

    // Add all entity listners
    func addPlayerListeners() -> [PlayerPublisher] {
        var listenerPublishers: [PlayerPublisher] = []
        let playersListener = PlayersListener(matchId: matchId)
        playersListener.startListening()

        listenerPublishers.append(playersListener.getPublisher())
        return listenerPublishers
    }
}
