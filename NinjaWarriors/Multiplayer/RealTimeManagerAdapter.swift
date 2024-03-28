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

    private func getEntititesDict() async throws -> [String: [String: Any]] {
        let dataSnapshot = try await entitiesRef.getData()
        guard let entitiesDict = dataSnapshot.value as? [String: [String: Any]] else {
            throw NSError(domain: "Invalid player data format", code: -1, userInfo: nil)
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

    func uploadEntity(entity: Entity, entityName: String, component: Component? = nil) async throws {
        var entityDict = try formEntityDict(from: entity)
        var components: [Component] = []

        if let component = component {
            components = [component]
        } else {
            components = entity.getInitializingComponents()
        }
        let componentDict = formComponentDict(from: components)

        if var existingComponentDict = entityDict[componentKey] as? [String: Any] {
            // Merge new component dictionary with existing one
            existingComponentDict.merge(componentDict) { (_, new) in new }
            // Update entityDict with merged component dictionary
            entityDict[componentKey] = existingComponentDict
        } else {
            // If componentKey does not exist, simply set the component dictionary
            entityDict[componentKey] = componentDict
        }

        try await entitiesRef.child(entityName).child(entity.id).setValue(entityDict)
    }

    /*
    // Updates player position, and / or additional one component at a time
    func updateEntity(id: EntityID, position: Point, component: Component? = nil) async throws {
        let entity = try await getEntity(entityId: id)
        guard let entity = entity else {
            return
        }
        guard let entityType = try await getWrapperType(from: entity.id) else {
            return
        }
        entity.shape.center.setCartesian(xCoord: position.xCoord, yCoord: position.yCoord)
        try await uploadEntity(entity: entity, entityName: entityType)
    }
    */

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
