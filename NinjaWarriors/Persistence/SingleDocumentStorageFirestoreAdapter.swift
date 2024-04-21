//
//  FirestoreStorageManager.swift
//  NinjaWarriors
//
//  Created by Jivesh Mohan on 21/4/24.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

class SingleDocumentStorageFirestoreAdapter: SingleDocumentStorageManager {
    private let collectionRef: CollectionReference
    private let userID: String

    init(collectionID: String, userID: String) {
        self.collectionRef = Firestore.firestore().collection(collectionID)
        self.userID = userID
    }

    func save<T: Codable>(_ object: T) {
        let docRef = collectionRef.document(userID)
        do {
            try docRef.setData(from: object)
        } catch {
            assertionFailure("Problem in firebase completion")
        }
    }

    func load<T: Decodable>(_ completion: @escaping (T?, Error?) -> Void) {
        let docRef = collectionRef.document(userID)

        docRef.getDocument { document, error in
            if let error = error as NSError? {
                completion(nil, error)
                return
            }
            guard let document = document else {
                completion(nil, nil)
                return
            }
            do {
                let decodedObject = try document.data(as: T.self)
                completion(decodedObject, nil)
            } catch {
                completion(nil, error)
            }
        }
    }
}
