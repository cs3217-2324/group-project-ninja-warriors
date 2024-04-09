//
//  FactoryListener.swift
//  NinjaWarriors
//
//  Created by Muhammad Reyaaz on 16/3/24.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

class FactoryListener<P: FactoryPublisher, W: FactoryWrapper>: Listener {
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

            let result = querySnapshot.documents.compactMap { document -> P.Item? in
                do {
                    let jsonData = try JSONSerialization.data(withJSONObject: document.data() )
                    let decoder = JSONDecoder()
                    return try decoder.decode(P.Item.self, from: jsonData)
                } catch {
                    print("Error decoding document data: \(error)")
                    return nil
                }
            }
            self.publisher.publish(result)
        }
    }

    func stopListening() {
        guard let firestoreListener = self.firestoreListener as? ListenerRegistration else {
            return
        }
        firestoreListener.remove()
        self.firestoreListener = nil
    }

    func getPublisher() -> P {
        return publisher
    }
}
