//
//  RealTimePlayersManagerAdapter.swift
//  NinjaWarriors
//
//  Created by Muhammad Reyaaz on 18/3/24.
//

import Foundation
import FirebaseDatabase

final class RealTimePlayersManagerAdapter: PlayersManager {
    private let databaseRef = Database.database().reference()
    private let playersRef: DatabaseReference

    init() {
        playersRef = databaseRef.child("players")
    }

    func uploadPlayer(player: Player) async throws {
        let playerData = try JSONEncoder().encode(player.toPlayerWrapper())
        guard let playerDict = try JSONSerialization.jsonObject(with: playerData, options: []) as? [String: Any] else {
            throw NSError(domain: "com.yourapp", code: -1, userInfo: [NSLocalizedDescriptionKey: "Failed to serialize player data"])
        }
        do {
            try await playersRef.child(player.id).setValue(playerDict)
        } catch {
            throw error
        }
    }

    func getPlayer(playerId: String) async throws -> Player {
        return try await withCheckedThrowingContinuation { continuation in
            playersRef.child(playerId).observeSingleEvent(of: .value) { snapshot, error in
                if let error = error {
                    continuation.resume(throwing: NSError(domain: "FirebaseError", code: 0, userInfo: ["error": error]))
                    return
                }
                guard let playerDict = snapshot.value as? [String: Any] else {
                    let decodingError = NSError(domain: "DecodingError", code: 0, userInfo: nil)
                    continuation.resume(throwing: decodingError)
                    return
                }
                do {
                    let playerData = try JSONSerialization.data(withJSONObject: playerDict, options: [])
                    let playerWrapper = try JSONDecoder().decode(PlayerWrapper.self, from: playerData)
                    let player = playerWrapper.toPlayer()
                    continuation.resume(returning: player)
                } catch {
                    continuation.resume(throwing: error)
                }
            }
        }
    }

    func updatePlayer(playerId: String, position: Point) async throws {
        var player = try await getPlayer(playerId: playerId)
        player.changePosition(to: position)
        try await uploadPlayer(player: player)
        /*
        let playerData = try JSONEncoder().encode(player.toPlayerWrapper())
        guard let playerDict = try JSONSerialization.jsonObject(with: playerData, options: []) as? [String: Any] else {
            throw NSError(domain: "com.yourapp", code: -1, userInfo: [NSLocalizedDescriptionKey: "Failed to serialize player data"])
        }
        do {
            try await playersRef.child(player.id).setValue(playerDict)
        } catch {
            throw error
        }
        */
    }

    func getAllPlayers(with playerIds: [String]) async throws -> [Player] {
        return []
    }

    func getAllPlayers() async throws -> [Player] {
        var players: [Player] = []

        do {
            let dataSnapshot = try await playersRef.getData()
            guard let playerDict = dataSnapshot.value as? [String: [String: Any]] else {
                throw NSError(domain: "Invalid player data format", code: -1, userInfo: nil)
            }

            for (_, value) in playerDict {
                guard let playerData = try? JSONSerialization.data(withJSONObject: value) else {
                    print("Failed to serialize player data")
                    continue
                }
                do {
                    let playerWrapper = try JSONDecoder().decode(PlayerWrapper.self, from: playerData)
                    let player = playerWrapper.toPlayer()
                    players.append(player)
                } catch {
                    print("Error decoding player data:", error)
                }
            }
        } catch {
            throw error
        }
        return players
    }

    func getAllPlayersCount() async throws -> Int {
        var count = 0
        let semaphore = DispatchSemaphore(value: 0)

        playersRef.observeSingleEvent(of: .value) { snapshot in
            if let playerDicts = snapshot.value as? [String: [String: Any]] {
                count = playerDicts.count
            }
            semaphore.signal()
        }

        semaphore.wait()
        return count
    }

    func addListenerForAllPlayers() -> PlayerPublisher {
        let playersListener = PlayersListener()
        playersListener.startListening()
        return playersListener.getPublisher()
    }
}
