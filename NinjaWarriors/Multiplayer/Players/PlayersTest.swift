//
//  PlayersTest.swift
//  NinjaWarriors
//
//  Created by Muhammad Reyaaz on 18/3/24.
//

import Foundation
import FirebaseDatabase

final class PlayersTest: PlayersManager {
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

    ///*
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
                    print("get player dict", playerDict)
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
    //*/

    /*
    func getPlayer(playerId: String) async throws -> Player {
        do {
            let dataSnapshot = try await playersRef.child(playerId).getData()

            guard let playerDict = dataSnapshot.value as? [String: Any] else {
                throw NSError(domain: "DecodingError", code: 0, userInfo: nil)
            }

            print("get player dict", playerDict)

            let playerData = try JSONSerialization.data(withJSONObject: playerDict, options: [])

            print("get player data", playerData)

            let playerWrapper = try JSONDecoder().decode(PlayerWrapper.self, from: playerData)

            print("get player wrapper", playerWrapper)

            let player = playerWrapper.toPlayer()
            print("get player", player)
            return player
        } catch {
            throw error
        }
    }
    */

    /*
    func getPlayer(playerId: String) async throws -> Player {
        do {
            let dataSnapshot = try await playersRef.child(playerId).getData()
            guard let playerDict = dataSnapshot.value as? [String: Any] else {
                throw NSError(domain: "DecodingError", code: 0, userInfo: nil)
            }

            guard let firstValue = playerDict.values.first as? [String: Any] else {
                throw NSError(domain: "DecodingError", code: 0, userInfo: nil)
            }

            let playerData = try JSONSerialization.data(withJSONObject: firstValue, options: [])
            let playerWrapper = try JSONDecoder().decode(PlayerWrapper.self, from: playerData)
            let player = playerWrapper.toPlayer()
            print("get player with id", player.id)
            return player
        } catch {
            throw error
        }
    }
    */

    func updatePlayer(playerId: String, position: Point) async throws {
        var player = try await getPlayer(playerId: playerId)
        player.changePosition(to: position)

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

    func getAllPlayers(with playerIds: [String]) async throws -> [Player] {
        return []
    }

    /*
    func getAllPlayers(with playerIds: [String]) async throws -> [Player] {
        var players: [Player] = []

        for playerId in playerIds {
            do {
                let playerData = try await playersRef.child(playerId).getData()
                if let playerDict = playerData.value as? [String: Any] {
                    let playerData = try JSONSerialization.data(withJSONObject: playerDict, options: [])
                    let playerWrapper = try JSONDecoder().decode(PlayerWrapper.self, from: playerData)
                    let player = playerWrapper.toPlayer()
                    players.append(player)
                }
            } catch {
                throw error
            }
        }

        return players
    }
    */

    /*
    func getAllPlayers() async throws -> [Player] {
        var players: [Player] = []

        do {
            let dataSnapshot = try await playersRef.getData()
            print("data snapshot", dataSnapshot)
            guard let playerDict = dataSnapshot.value as? [String: [String: Any]] else {
                throw NSError(domain: "Invalid player data format", code: -1, userInfo: nil)
            }

            print("player dict", playerDict)

            for (_, value) in playerDict {
                let playerData = try JSONSerialization.data(withJSONObject: value)
                print("player data", playerData)
                let playerWrapper = try JSONDecoder().decode(PlayerWrapper.self, from: playerData)
                print("player wrapper", playerWrapper)
                let player = playerWrapper.toPlayer()
                players.append(player)
            }
        } catch {
            throw error
        }

        return players
    }
    */

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




    /*
    func getPlayerSnapshots(with playerIds: [String]) async throws -> [DataSnapshot] {
        var playerSnapshots: [DataSnapshot] = []
        for playerId in playerIds {
            do {
                let snapshot = try await playersRef.child(playerId).observeSingleEvent(of: .value).get()
                playerSnapshots.append(snapshot)
            } catch {
                throw error
            }
        }
        return playerSnapshots
    }
    */

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
