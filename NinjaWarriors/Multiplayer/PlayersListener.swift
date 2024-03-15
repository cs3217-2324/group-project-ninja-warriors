//
//  PlayersListener.swift
//  NinjaWarriors
//
//  Created by Muhammad Reyaaz on 16/3/24.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

class PlayersListener {
    private let publisher = PlayerPublisher()
    private var firestoreListener: Any?
    private let playersCollection = Firestore.firestore().collection("players")

    private func getAllPlayersQuery() -> Query {
        playersCollection
    }

    func startListening() {
        self.firestoreListener = getAllPlayersQuery().addSnapshotListener { querySnapshot, error in
            if let error = error {
                self.publisher.publishError(error)
                return
            }

            guard let querySnapshot = querySnapshot else { return }

            let players = querySnapshot.documents.compactMap { document -> PlayerWrapper? in
                do {
                    let jsonData = try JSONSerialization.data(withJSONObject: document.data() )
                    let decoder = JSONDecoder()
                    return try decoder.decode(PlayerWrapper.self, from: jsonData)
                } catch {
                    print("Error decoding document data: \(error)")
                    return nil
                }
            }

            self.publisher.publish(players)
        }
    }

    func stopListening() {
        //self.firestoreListener?.remove()
    }

    func getPublisher() -> PlayerPublisher {
        return publisher
    }
}
