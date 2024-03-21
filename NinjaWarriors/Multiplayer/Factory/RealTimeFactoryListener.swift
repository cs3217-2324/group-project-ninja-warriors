//
//  RealTimeFactoryListener.swift
//  NinjaWarriors
//
//  Created by Muhammad Reyaaz on 18/3/24.
//

import Foundation
import FirebaseDatabase

class RealTimeFactoryListener<P: FactoryPublisher, W: FactoryWrapper>: Listener where W.Item == P.Item {

    internal let publisher: P
    private var databaseReference: DatabaseReference?
    private let referenceName: String
    private let database = Database.database()

    init(referenceName: String, publisher: P) {
        self.referenceName = referenceName
        self.publisher = publisher
    }

    private func getAllReference() -> DatabaseReference {
        database.reference().child(referenceName)
    }

    /*
     let dataSnapshot = try await getAllReference().getData()
     guard let entitiesDict = dataSnapshot.value as? [String: [String: Any]] else {
         throw NSError(domain: "Invalid player data format", code: -1, userInfo: nil)
     }

     var entities: [Entity] = []
     let entityTypes = Array(entitiesDict.keys)
     print("entity types", entityTypes)

     for entityType in entityTypes {
         guard let entitiesData = entitiesDict[entityType] else {
             return
         }
     */

    func getEntityTypes() async throws -> [String] {
        let dataSnapshot = try await getAllReference().getData()
        guard let entitiesDict = dataSnapshot.value as? [String: [String: Any]] else {
            throw NSError(domain: "Invalid player data format", code: -1, userInfo: nil)
        }
        let entityTypes = Array(entitiesDict.keys)
        return entityTypes
    }

    /*
    func startListening() async throws {
        let entityTypes = try await getEntityTypes()
        for entityType in entityTypes {
            self.databaseReference = getAllReference().child(entityType)
            self.databaseReference?.observe(.value) { snapshot in
                guard let dataSnapshot = snapshot.children.allObjects as? [DataSnapshot] else { return }
                print("data snapshot", dataSnapshot)
                let result = dataSnapshot.compactMap { dataSnap -> P.Item? in
                    print("data snap value", dataSnap.value)
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
    }
    */

    /// *
    func startListening() {
        self.databaseReference = getAllReference().child("Player")
        self.databaseReference?.observe(.value) { snapshot in
            guard let dataSnapshot = snapshot.children.allObjects as? [DataSnapshot] else { return }
            print("data snapshot", dataSnapshot)
            let result = dataSnapshot.compactMap { dataSnap -> P.Item? in
                guard let dataValue = dataSnap.value,
                      let jsonData = try? JSONSerialization.data(withJSONObject: dataValue),
                      let decoder = try? JSONDecoder().decode(P.Item.self, from: jsonData) else {
                    return nil
                }
                let testDecoder = try? JSONDecoder().decode(PlayerWrapper.self, from: jsonData)
                print("testDecoder", testDecoder?.toEntity())
                print("data snap value", dataValue)
                print("json data", jsonData)
                print("decoder", decoder)
                return decoder
            }
            self.publisher.publish(result)
        }
    }
    // */

    /*
    func startListening() {
        self.databaseReference = database.reference().child(referenceName)
        self.databaseReference?.observe(.value) { snapshot in
            guard let dataSnapshot = snapshot.children.allObjects as? [DataSnapshot] else { return }
            print("data snapshot", dataSnapshot)
            let result = dataSnapshot.compactMap { dataSnap -> P.Item? in
                print("data snap value", dataSnap.value)
                guard let dataValue = dataSnap.value,
                      let jsonData = try? JSONSerialization.data(withJSONObject: dataValue),
                      let decoder = try? JSONDecoder().decode(P.Item.self, from: jsonData) else {
                    return nil
                }
                return decoder
            }
            print("result", result)
            self.publisher.publish(result)
        }
    }
    */

    func stopListening() {
        self.databaseReference?.removeAllObservers()
    }

    func getPublisher() -> P {
        return publisher
    }
}
