//
//  RealTimeFactoryListener.swift
//  NinjaWarriors
//
//  Created by Muhammad Reyaaz on 18/3/24.
//

import Foundation
import FirebaseDatabase

class RealTimeFactoryListener<P: FactoryPublisher, W: FactoryWrapper>: Listener {

    internal let publisher: P
    private var databaseReference: DatabaseReference?
    private let referenceName: String
    private let entityName: String
    private let database = Database.database()

    init(referenceName: String, publisher: P, entityName: String) {
        self.referenceName = referenceName
        self.publisher = publisher
        self.entityName = entityName
    }

    private func getAllReference() -> DatabaseReference {
        database.reference().child(referenceName)
    }

    func startListening() {
        self.databaseReference = getAllReference().child(entityName)
        self.databaseReference?.observe(.value) { snapshot in
            guard let dataSnapshot = snapshot.children.allObjects as? [DataSnapshot] else { return }
            let result = dataSnapshot.compactMap { dataSnap -> P.Item? in
                guard let dataValue = dataSnap.value,
                      let jsonData = try? JSONSerialization.data(withJSONObject: dataValue),
                      let decoder = try? JSONDecoder().decode(P.Item.self, from: jsonData) else {
                    return nil
                }
                return decoder
            }
            self.publisher.publish(result)
        }
    }

    func stopListening() {
        self.databaseReference?.removeAllObservers()
    }

    func getPublisher() -> P {
        return publisher
    }
}
