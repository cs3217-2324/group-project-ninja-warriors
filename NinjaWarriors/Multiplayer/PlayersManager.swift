//
//  PlayersManager.swift
//  NinjaWarriors
//
//  Created by Muhammad Reyaaz on 15/3/24.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift
import Combine

final class PlayersManager {

    // TODO: Replace Singleton with Dependency Injection
    static let shared = PlayersManager()
    private init() { }

    private let playersCollection = Firestore.firestore().collection("players")

    private let encoder: Firestore.Encoder = {
        let encoder = Firestore.Encoder()
        return encoder
    }()

    private let decoder: Firestore.Decoder = {
        let decoder = Firestore.Decoder()
        return decoder
    }()

    private var playersListener: ListenerRegistration? = nil

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

    private func getAllPlayersQuery() -> Query {
        playersCollection
    }

    private func getAllPlayersSortedByLengthQuery(descending: Bool) -> Query {
        playersCollection.order(by: "halfLength", descending: descending)
    }

    func getAllPlayers(lengthDescending descending: Bool?, count: Int, lastDocument: DocumentSnapshot?) async throws -> (players: [Player], lastDocument: DocumentSnapshot?) {
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

    func addListenerForAllPlayers(playerId: String, completion: @escaping (_ players: [Player]) -> Void) {
        self.playersListener = getAllPlayersQuery().addSnapshotListener { querySnapshot, error in
            guard let documents = querySnapshot?.documents else {
                print("No documents")
                return
            }

            let playersWrapper: [PlayerWrapper] = documents.compactMap({ try? $0.data(as: PlayerWrapper.self) })
            var players: [Player] = []
            for player in playersWrapper {
                players.append(player.toPlayer())
            }
            completion(players)

            querySnapshot?.documentChanges.forEach { diff in
                print(diff.document.data())
            }
        }
    }

    func addListenerForAllUserFavoriteProducts(playerId: String) -> AnyPublisher<[Player], Error> {
        //let (publisher, listener) = getPlayer(playerId: playerId).addSnapshotListener(as: PlayerW)
            //.addSnapshotListener(as: Player.self)

        self.playersListener = listener
        return publisher
    }
}
