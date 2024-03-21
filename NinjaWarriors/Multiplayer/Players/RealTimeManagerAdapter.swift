//
//  RealTimeManagerAdapter.swift
//  NinjaWarriors
//
//  Created by Muhammad Reyaaz on 18/3/24.
//

import Foundation
import FirebaseDatabase

// TODO: Remove all force unwraps
final class RealTimeManagerAdapter: EntitiesManager {

    private let databaseRef = Database.database().reference()
    private var entitiesRef: DatabaseReference
    private let matchId: String

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

    // MARK: Dynamically retrieve entity type based on key in database by mapping key -> keyWrapper
    private func getWrapperType(of entityType: String) -> Codable.Type? {
        let wrapperTypeName = "\(entityType.capitalized)Wrapper"
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
        let entityWrapper: EntityWrapper = try JSONDecoder().decode(wrapper, from: entityData) as! EntityWrapper
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
                guard let dataDict = entitiesDict[entityType]?[entityId] else {
                    return (nil, nil)
                }
                guard let entity = try getEntity(from: dataDict, with: wrapperType) else {
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

    func uploadEntity(entity: Entity) async throws {
        let entity = try await getEntity(entityId: entity.id)

        guard let entity = entity, let entityType = try await getWrapperType(from: entity.id) else {
            return
        }

        let entityData = try JSONEncoder().encode(entity.wrapper())

        guard let entityDict = try JSONSerialization.jsonObject(with: entityData, options: []) as? [String: Any] else {
            throw NSError(domain: "com.yourapp", code: -1,
                          userInfo: [NSLocalizedDescriptionKey: "Failed to serialize player data"])
        }
        try await entitiesRef.child(entityType).child(entity.id).setValue(entityDict)
    }

    // Update only player position for now.
    // TODO: Change to system
    func updateEntity(id: String, position: Point, component: Component? = nil) async throws {
        let entity = try await getEntity(entityId: id)
        guard let entity = entity else {
            return
        }
        entity.shape.center.setCartesian(xCoord: position.xCoord, yCoord: position.yCoord)
        try await uploadEntity(entity: entity)
    }

    // Add all entity listners here
    func addListeners() -> [any FactoryPublisher] {
        var listenerPublishers: [any FactoryPublisher] = []
        let playersListener = PlayersListener(matchId: matchId)
        playersListener.startListening()

        listenerPublishers.append(playersListener.getPublisher())
        return listenerPublishers
    }
}
