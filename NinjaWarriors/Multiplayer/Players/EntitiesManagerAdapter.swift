//
//  EntitiesManagerAdapter.swift
//  NinjaWarriors
//
//  Created by Muhammad Reyaaz on 15/3/24.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

// TODO: Convert to general adapter that takes in any collection name
/*
final class EntitiesManagerAdapter: EntitiesManager {

    // TODO: Convert to REST API
    private let playersCollection = Firestore.firestore().collection("players")
    private var playersListener: ListenerRegistration?

    private func playerDocument(entityId: String) -> DocumentReference {
        playersCollection.document(entityId)
    }

    func uploadEntity(entity: Entity) async throws {
        try playerDocument(entityId: String(entity.id)).setData(from: entity.wrapper(), merge: false)
    }

    func getEntity(entityId: String) async throws -> Entity? {
        let wrapper = try await playerDocument(entityId: entityId).getDocument(as: PlayerWrapper.self)
        return wrapper.toEntity()
    }

    func updateEntity(id: String, position: Point) async throws {
        var player = try await getEntity(entityId: id)
        guard let player = player as? Player else {
            return
        }
        player.changePosition(to: position)

        let playerWrapper = player.wrapper()
        let playerData = try Firestore.Encoder().encode(playerWrapper)
        let documentRef = playerDocument(entityId: String(player.id))
        try await documentRef.updateData(playerData)
    }

    private func getAllPlayersQuery() -> Query {
        playersCollection
    }

    private func getAllPlayersSortedByLengthQuery(descending: Bool) -> Query {
        playersCollection.order(by: "halfLength", descending: descending)
    }

    func getAllPlayers(with playerIds: [String]) async throws -> [Player] {
        try await getAllPlayers(lengthDescending: true,
                                count: Constants.playerCount,
                                playerIds: playerIds,
                                lastDocument: nil).0
    }

    func getAllPlayers(lengthDescending descending: Bool?,
                       count: Int, playerIds: [String],
                       lastDocument: DocumentSnapshot?) async throws ->
    (players: [Player], lastDocument: DocumentSnapshot?) {
        let query: Query = getAllPlayersQuery().whereField("id", in: playerIds)
        let result = try await query.startOptionally(afterDocument: lastDocument)
            .getDocumentsWithSnapshot(as: PlayerWrapper.self)
        let players = result.players.map { $0.toPlayer() }
        return (players, result.lastDocument)
    }

    /*
    func getAllPlayersCount() async throws -> Int {
        try await playersCollection
            .aggregateCount()
    }
    */

    func addListenerForAllPlayers() -> EntityPublisher {
        let playersListener = PlayersListener()
        playersListener.startListening()
        return playersListener.getPublisher()
    }
}
*/