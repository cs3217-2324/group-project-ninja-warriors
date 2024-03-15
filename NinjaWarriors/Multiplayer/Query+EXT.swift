//
//  Query+EXT.swift
//  NinjaWarriors
//
//  Created by Muhammad Reyaaz on 15/3/24.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift
//import Combine

extension Query {

    func getDocuments<T>(as type: T.Type) async throws -> [T] where T : Decodable {
        try await getDocumentsWithSnapshot(as: type).players
    }

    func getDocumentsWithSnapshot<T>(as type: T.Type) async throws -> (players: [T], lastDocument: DocumentSnapshot?) where T : Decodable {
        let snapshot = try await self.getDocuments()

        let players = try snapshot.documents.map({ document in
            try document.data(as: T.self)
        })

        return (players, snapshot.documents.last)
    }

    func startOptionally(afterDocument lastDocument: DocumentSnapshot?) -> Query {
        guard let lastDocument else {
            return self
        }
        return self.start(afterDocument: lastDocument)
    }

    func aggregateCount() async throws -> Int {
        let snapshot = try await self.count.getAggregation(source: .server)
        return Int(truncating: snapshot.count)
    }

    func addSnapshotListener<T>(
        for type: T.Type = T.self,
        completion: @escaping (Result<[T], Error>) -> Void
    ) -> ListenerRegistration where T: Decodable {
        let listener = self.addSnapshotListener { querySnapshot, error in
            if let error = error {
                completion(.failure(error))
                return
            }

            guard let querySnapshot = querySnapshot else {
                print("No snapshot")
                completion(.success([]))
                return
            }

            let items: [T] = querySnapshot.documents.compactMap {
                try? $0.data(as: T.self)
            }

            completion(.success(items))
        }

        return listener
    }

    /*
    func addSnapshotListener<T>(as type: T.Type) -> (AnyPublisher<[T], Error>, ListenerRegistration) where T : Decodable {
        let publisher = PassthroughSubject<[T], Error>()

        let listener = self.addSnapshotListener { querySnapshot, error in
            guard let documents = querySnapshot?.documents else {
                print("No documents")
                return
            }

            let players: [T] = documents.compactMap({
                try? $0.data(as: T.self)
            })
            publisher.send(players)
        }
        return (publisher.eraseToAnyPublisher(), listener)
    }
    */
}

// Define a custom subject similar to PassthroughSubject
class CustomSubject<Output, Failure: Error>: Publisher {
    private var valueHandler: ((Output) -> Void)?
    private var completionHandler: ((Result<(), Failure>) -> Void)?

    func send(_ value: Output) {
        valueHandler?(value)
    }

    func send(completion: Result<(), Failure>) {
        completionHandler?(completion)
    }

    func subscribe(_ receiveValue: @escaping (Output) -> Void, _ receiveCompletion: @escaping (Result<(), Failure>) -> Void) {
        valueHandler = receiveValue
        completionHandler = receiveCompletion
    }
}
