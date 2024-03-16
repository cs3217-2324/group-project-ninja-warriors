//
//  FactoryListener.swift
//  NinjaWarriors
//
//  Created by Muhammad Reyaaz on 16/3/24.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

class FactoryListener<P: FactoryPublisher, W: FactoryWrapper>: Listener where W.T == P.T {
    internal let publisher: P
    private var firestoreListener: Any?
    private let collectionName: String
    private let firestore = Firestore.firestore()

    init(collectionName: String, publisher: P) {
        self.collectionName = collectionName
        self.publisher = publisher
    }

    private func getAllQuery() -> Query {
        firestore.collection(collectionName)
    }

    func startListening() {
        self.firestoreListener = getAllQuery().addSnapshotListener { querySnapshot, error in
            if let error = error {
                self.publisher.publishError(error)
                return
            }

            guard let querySnapshot = querySnapshot else { return }

            let result = querySnapshot.documents.compactMap { document -> P.T? in
                do {
                    let jsonData = try JSONSerialization.data(withJSONObject: document.data() )
                    let decoder = JSONDecoder()
                    return try decoder.decode(P.T.self, from: jsonData)
                } catch {
                    print("Error decoding document data: \(error)")
                    return nil
                }
            }
            self.publisher.publish(result)
        }
    }

    func stopListening() {
        // Stop firestore listener
    }

    func getPublisher() -> P {
        return publisher
    }
}

