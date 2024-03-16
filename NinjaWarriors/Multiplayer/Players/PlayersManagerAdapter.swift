//
//  PlayersManagerAdapter.swift
//  NinjaWarriors
//
//  Created by Muhammad Reyaaz on 15/3/24.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

final class PlayersManagerAdapter: PlayersManager {

    // TODO: Convert to REST API
    private let playersCollection = Firestore.firestore().collection("players")
    private var playersListener: ListenerRegistration?

    private func playerDocument(playerId: String) -> DocumentReference {
        playersCollection.document(playerId)
    }

    func uploadPlayer(player: Player) async throws {
        try playerDocument(playerId: String(player.id)).setData(from: player.toPlayerWrapper(), merge: false)
    }

    func getPlayer(playerId: String) async throws -> Player {
        let wrapper = try await playerDocument(playerId: playerId).getDocument(as: PlayerWrapper.self)
        return wrapper.toPlayer()
    }

    func updatePlayer(playerId: String, position: Point) async throws {
        let player = try await getPlayer(playerId: playerId)
        player.changePosition(to: position)

        let playerWrapper = player.toPlayerWrapper()
        let playerData = try Firestore.Encoder().encode(playerWrapper)
        let documentRef = playerDocument(playerId: String(player.id))
        try await documentRef.updateData(playerData)
    }

    private func getAllPlayersQuery() -> Query {
        playersCollection
    }

    private func getAllPlayersSortedByLengthQuery(descending: Bool) -> Query {
        playersCollection.order(by: "halfLength", descending: descending)
    }

    func getAllPlayers(lengthDescending descending: Bool?,
                       count: Int,
                       lastDocument: DocumentSnapshot?) async throws ->
    (players: [Player], lastDocument: DocumentSnapshot?) {
        var query: Query = getAllPlayersQuery()

        if let descending {
            query = getAllPlayersSortedByLengthQuery(descending: descending)
        }
        let result = try await query.startOptionally(afterDocument: lastDocument)
            .getDocumentsWithSnapshot(as: PlayerWrapper.self)
        let players = result.players.map { $0.toPlayer() }
        return (players, result.lastDocument)
    }

    func getAllPlayersCount() async throws -> Int {
        try await playersCollection
            .aggregateCount()
    }

    func addListenerForAllPlayers() -> PlayerPublisher {
        let playersListener = PlayersListener()
        playersListener.startListening()
        return playersListener.getPublisher()
    }
}
