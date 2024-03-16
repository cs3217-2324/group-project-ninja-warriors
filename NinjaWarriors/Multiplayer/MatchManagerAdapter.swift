//
//  MatchManagerAdapter.swift
//  NinjaWarriors
//
//  Created by Muhammad Reyaaz on 16/3/24.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

final class MatchManagerAdapter: MatchManager {

    // TODO: Convert to REST API
    private let matches = Firestore.firestore().collection("matches")
    private var matchesListener: ListenerRegistration? = nil

    func createMatch() async throws -> String {
        let newMatchRef = matches.document()
        let data: [String: Any] = [
            "count": 0,
            "ready_players": []
        ]
        try await newMatchRef.setData(data)
        return newMatchRef.documentID
    }

    func getMatch(limit: Int) async throws -> DocumentSnapshot? {
        try await matches
            .whereField("count", isEqualTo: limit)
            .getDocuments()
            .documents.first
    }

    func getMatchBelowLimit(limit: Int) async throws -> DocumentSnapshot? {
        try await matches
            .whereField("count", isLessThan: limit)
            .order(by: "count", descending: true)
            .limit(to: 1)
            .getDocuments()
            .documents.first
    }

    func addPlayerToMatch(playerId: String, matchId: String) async {
        let matchRef = matches.document(matchId)
        do {
            _ = try await Firestore.firestore().runTransaction({ (transaction, errorPointer) -> Any? in
                do {
                    let matchDocument = try transaction.getDocument(matchRef)
                    guard var matchData = matchDocument.data(),
                          var readyPlayers = matchData["ready_players"] as? [String] else {
                        return nil
                    }
                    readyPlayers.append(playerId)
                    matchData["ready_players"] = readyPlayers
                    transaction.setData(matchData, forDocument: matchRef)
                } catch let error as NSError {
                    errorPointer?.pointee = error
                }
                return nil
            })
        } catch {
            print("Error adding player to match: \(error)")
        }
    }

    func removePlayerFromMatch(playerId: String, matchId: String) async {
        let matchRef = matches.document(matchId)
        do {
            _ = try await Firestore.firestore().runTransaction({ (transaction, errorPointer) -> Any? in
                do {
                    let matchDocument = try transaction.getDocument(matchRef)
                    guard var matchData = matchDocument.data(),
                          var readyPlayers = matchData["ready_players"] as? [String] else {
                        return nil
                    }
                    if let index = readyPlayers.firstIndex(of: playerId) {
                        readyPlayers.remove(at: index)
                    }
                    matchData["ready_players"] = readyPlayers
                    transaction.setData(matchData, forDocument: matchRef)
                } catch let error as NSError {
                    errorPointer?.pointee = error
                }
                return nil
            })
        } catch {
            print("Error removing player from match: \(error)")
        }
    }

    func addListenerForAllMatches() -> PlayerPublisher {
        let matchesListener = PlayersListener()
        matchesListener.startListening()
        return matchesListener.getPublisher()
    }
}
