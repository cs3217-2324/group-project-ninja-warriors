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
    private var playersRef: DatabaseReference
    private let matchId: String
    // private let databaseRefName = "playwers"

    init(matchId: String) {
        self.matchId = matchId
        playersRef = databaseRef.child(matchId)
    }

    func decodeEntities/*<T: Entity>*/(id: EntityID? = nil) async throws -> [Entity]? {

        let dataSnapshot = try await playersRef.getData()
        guard let entitiesDict = dataSnapshot.value as? [String: [String: Any]] else {
            throw NSError(domain: "Invalid player data format", code: -1, userInfo: nil)
        }

        var entities: [Entity] = []
        let entityTypes = Array(entitiesDict.keys)
        print("entity types", entityTypes)

        for entityType in entityTypes {
            guard let entitiesData = entitiesDict[entityType] else {
                return nil
            }
            let entityIds = Array(entitiesData.keys)

            print("entity ids", entityIds)

            for entityId in entityIds {
                if id != nil && entityId != id {
                    print(entityId, id, entityId == id)
                    continue
                }

                let wrapperTypeName = "\(entityType.capitalized)Wrapper"
                print("wrapperName", wrapperTypeName)
                guard let wrapperType = NSClassFromString("NinjaWarriors." + wrapperTypeName) as? Codable.Type else {
                    print(NSClassFromString("NinjaWarriors." + wrapperTypeName))
                    return nil
                }
                print("wrapperType", wrapperType)
                guard let dataDict = entitiesData[entityId] else {
                    return nil
                }
                print("data dict", dataDict)

                let entityData = try JSONSerialization.data(withJSONObject: dataDict, options: [])
                print("entity data", entityData)
                let entityWrapper: EntityWrapper = try JSONDecoder().decode(wrapperType, from: entityData) as! EntityWrapper
                print("test entity wrapper", entityWrapper)
                guard let entity = entityWrapper.toEntity() else {
                    return nil
                }
                print("test entity", entity)
                entities.append(entity)
            }
        }
        return entities
    }

    /*
    var players: [Entity] = []
    for (_, value) in playerDict {
        guard let player = try decodePlayer(from: value) else {
            continue
        }
        // TODO: Remove force unwrap
        guard playerIds == nil || playerIds!.contains(player.id) else {
            continue
        }
        players.append(player)
    }
    return players
    */

    /*
    private func decodePlayer(from dictionary: [String: Any]) throws -> Entity? {
        let playerData = try JSONSerialization.data(withJSONObject: dictionary, options: [])
        let playerWrapper = try JSONDecoder().decode(PlayerWrapper.self, from: playerData)
        return playerWrapper.toEntity()
    }

    private func decodePlayers(from playerDict: [String: [String: Any]],
                               with playerIds: [String]?) async throws -> [Entity] {
        var players: [Entity] = []
        for (_, value) in playerDict {
            guard let player = try decodePlayer(from: value) else {
                continue
            }
            // TODO: Remove force unwrap
            guard playerIds == nil || playerIds!.contains(player.id) else {
                continue
            }
            players.append(player)
        }
        return players
    }

    func getAllEntities(with ids: [String]) async throws -> [Entity] {
        do {
            let dataSnapshot = try await playersRef.getData()
            guard let playerDict = dataSnapshot.value as? [String: [String: Any]] else {
                throw NSError(domain: "Invalid player data format", code: -1, userInfo: nil)
            }
            let players = try await decodePlayers(from: playerDict, with: ids)
            return players
        } catch {
            throw error
        }
    }
    */

    func getAllEntities() async throws -> [Entity]? {
        guard let entities = try await decodeEntities() else {
            return nil
        }
        return entities
    }

    /*
    func getEntity(entityId: String) async throws -> Entity {
        return try await withCheckedThrowingContinuation { continuation in
            playersRef.child(entityId).observeSingleEvent(of: .value) { [weak self] snapshot, error in
                guard let self = self else { return }

                if let error = error {
                    continuation.resume(throwing: NSError(domain: "FirebaseError",
                                                          code: 0, userInfo: ["error": error]))
                    return
                }
                guard let playerDict = snapshot.value as? [String: Any] else {
                    let decodingError = NSError(domain: "DecodingError", code: 0, userInfo: nil)
                    continuation.resume(throwing: decodingError)
                    return
                }

                do {
                    let player = try self.decodePlayer(from: playerDict)
                    continuation.resume(returning: player!)
                } catch {
                    continuation.resume(throwing: error)
                }
            }
        }
    }
    */

    func getEntity(entityId: EntityID) async throws -> Entity? {
        guard let entity = try await decodeEntities(id: entityId) else {
            return nil
        }
        print("get entity", entity)
        return entity[0]
    }

    func uploadEntity(entity: Entity, entityType: String) async throws {
        let playerData = try JSONEncoder().encode(entity.wrapper())
        guard let playerDict = try JSONSerialization.jsonObject(with: playerData, options: []) as? [String: Any] else {
            throw NSError(domain: "com.yourapp", code: -1,
                          userInfo: [NSLocalizedDescriptionKey: "Failed to serialize player data"])
        }
        do {
            try await playersRef.child(entityType).child(entity.id).setValue(playerDict)
        } catch {
            throw error
        }
    }

    // Update only player position for now
    func updateEntity(id: String, position: Point, entityType: String) async throws {
        var player = try await getEntity(entityId: id)
        print("update get player", player, id, entityType)
        guard let player = player as? Player else {
            return
        }
        player.changePosition(to: position)
        try await uploadEntity(entity: player, entityType: entityType)
    }

    /*
    func addListenerForAllEntities() -> EntityPublisher {
        let playersListener = PlayersListener(matchId: matchId)
        Task {
            try await playersListener.startListening()
        }
        return playersListener.getPublisher()
    }
    */

    func addListenerForAllEntities() -> EntityPublisher {
        let playersListener = PlayersListener(matchId: matchId)
        playersListener.startListening()
        return playersListener.getPublisher()
    }

}

/*
 import Foundation
 import Firebase

 // Define a protocol for entities
 protocol Entity: Codable {
     // Define any common properties or methods here
 }

 // Define a wrapper that can handle any entity
 struct EntityWrapper<T: Entity>: Codable {
     let entity: T

     // Method to convert to Entity
     func toEntity() -> Entity {
         return entity
     }
 }

 // Define a struct to represent match data
 struct MatchData {
     var players: [String: Any] // player_id: playerData
     // Add other entity types as needed
 }

 // Function to decode entities dynamically
 func decodeEntity<T: Entity>(from dictionary: [String: Any], entityType: String) throws -> T? {
     guard let entityData = dictionary[entityType] as? [String: Any] else {
         return nil
     }

     // Get the corresponding wrapper type dynamically
     let wrapperTypeName = "\(entityType.capitalized)Wrapper"
     guard let wrapperType = NSClassFromString(wrapperTypeName) as? Codable.Type else {
         return nil
     }

     // Convert entityData to Data
     let entityData = try JSONSerialization.data(withJSONObject: entityData, options: [])

     // Decode the data using the wrapper type
     let entityWrapper = try JSONDecoder().decode(wrapperType, from: entityData)

     // Convert to Entity
     return (entityWrapper as? EntityWrapper<T>)?.entity
 }

 // Function to fetch all entities for a match
 func getAllEntities(matchID: String, completion: @escaping (MatchData?) -> Void) {
     // Assuming you have a Firebase reference
     let matchRef = Database.database().reference().child(matchID)
     matchRef.observeSingleEvent(of: .value) { snapshot in
         guard let data = snapshot.value as? [String: Any] else {
             completion(nil)
             return
         }

         let matchData = MatchData(
             players: data["players"] as? [String: Any] ?? [:]
             // Add other entity types as needed
         )
         completion(matchData)
     }
 }

 // Function to upload an entity for a match
 func uploadEntity<T: Entity>(matchID: String, entityID: String, entityType: String, entity: T) {
     // Assuming you have a Firebase reference
     let matchRef = Database.database().reference().child(matchID)
     let entityData: [String: Any] = [entityType: entity]
     matchRef.child(entityID).setValue(entityData)
 }

 // Function to update an entity for a match
 func updateEntity<T: Entity>(matchID: String, entityID: String, entityType: String, entity: T) {
     // Assuming you have a Firebase reference
     let matchRef = Database.database().reference().child(matchID)
     let entityData: [String: Any] = [entityType: entity]
     matchRef.child(entityID).updateChildValues(entityData)
 }

 // Example usage
 let matchID = "match_id_1"
 getAllEntities(matchID: matchID) { matchData in
     guard let matchData = matchData else {
         print("Failed to fetch match data")
         return
     }

     if let player: Player = try decodeEntity(from: matchData.players, entityType: "player") {
         print("Decoded player: \(player)")
     } else {
         print("Failed to decode player")
     }
 }

 // Upload or update entities as needed
 let player = Player(/* Initialize player properties */)
 uploadEntity(matchID: matchID, entityID: "player_id_1", entityType: "player", entity: player)

 */
