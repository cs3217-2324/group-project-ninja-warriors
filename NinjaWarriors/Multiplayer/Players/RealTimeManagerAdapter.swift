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
    private let playersRef: DatabaseReference
    private let databaseRefName = "players"

    init() {
        playersRef = databaseRef.child(databaseRefName)
    }

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

    func uploadEntity(entity: Entity) async throws {
        let playerData = try JSONEncoder().encode(entity.wrapper())
        guard let playerDict = try JSONSerialization.jsonObject(with: playerData, options: []) as? [String: Any] else {
            throw NSError(domain: "com.yourapp", code: -1,
                          userInfo: [NSLocalizedDescriptionKey: "Failed to serialize player data"])
        }
        do {
            try await playersRef.child(entity.id).setValue(playerDict)
        } catch {
            throw error
        }
    }

    // Update only player position for now
    func updateEntity(id: String, position: Point) async throws {
        var player = try await getEntity(entityId: id)
        guard let player = player as? Player else {
            return
        }
        player.changePosition(to: position)
        try await uploadEntity(entity: player)
    }

    func addListenerForAllEntities() -> EntityPublisher {
        let playersListener = PlayersListener()
        playersListener.startListening()
        return playersListener.getPublisher()
    }
}
