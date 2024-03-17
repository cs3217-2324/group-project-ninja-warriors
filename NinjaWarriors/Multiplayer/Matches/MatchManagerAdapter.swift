//
//  MatchManagerAdapter.swift
//  NinjaWarriors
//
//  Created by Muhammad Reyaaz on 16/3/24.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

// TODO: Convert to REST API
final class MatchManagerAdapter: MatchManager {
    private let collection = "matches"
    private let countLabel = "count"
    private let playersLabel = "ready_players"
    private let idLabel = "id"
    private let matches = Firestore.firestore().collection("matches")
    private var matchesListener: ListenerRegistration?

    func enterQueue(playerId: String) async throws -> String {
        guard let matchToQueue = try await getMatchBelowLimit(limit: Constants.playerCount) else {
            let newMatch = try await createMatch()
            await addPlayerToMatch(playerId: playerId, matchId: newMatch)
            return newMatch
        }
        await addPlayerToMatch(playerId: playerId, matchId: matchToQueue)
        return matchToQueue
    }

    func startMatch() async throws -> String? {
        try await getMatch(limit: Constants.playerCount)
    }

    internal func createMatch() async throws -> String {
        let newMatchRef = matches.document()
        let documentID = newMatchRef.documentID
        let data: [String: Any] = [
            countLabel: 0,
            playersLabel: [],
            idLabel: documentID
        ]
        try await newMatchRef.setData(data)
        return newMatchRef.documentID
    }

    internal func getMatch(limit: Int) async throws -> String? {
        let querySnapshot = try await matches.getDocuments()
        for document in querySnapshot.documents {
            if let count = document.data()[countLabel] as? Int {
                if count == limit {
                    return document.documentID
                }
            }
        }
        return nil
    }

    internal func getMatchBelowLimit(limit: Int) async throws -> String? {
        let querySnapshot = try await matches.getDocuments()
        for document in querySnapshot.documents {
            if let count = document.data()[countLabel] as? Int {
                if count < limit {
                    return document.documentID
                }
            }
        }
        return nil
    }

    func getMatchCount(matchId: String) async throws -> Int? {
        let matchRef = matches.document(matchId)
        let documentSnapshot = try await matchRef.getDocument()

        if let matchData = documentSnapshot.data(),
           let count = matchData[countLabel] as? Int {
            return count
        } else {
            return nil
        }
    }

    internal func addPlayerToMatch(playerId: String, matchId: String) async {
        let matchRef = matches.document(matchId)
        do {
            _ = try await Firestore.firestore().runTransaction { transaction, errorPointer in
                do {
                    try self.updateMatchData(transaction: transaction, matchRef: matchRef, playerId: playerId)
                } catch let error as NSError {
                    errorPointer?.pointee = error
                }
                return nil
            }
        } catch {
            print("Error adding player to match: \(error)")
        }
    }

    private func updateMatchData(transaction: Transaction, matchRef: DocumentReference, playerId: String) throws {
        let matchDocument = try transaction.getDocument(matchRef)
        var matchData = matchDocument.data() ?? [:]
        guard let readyPlayers = matchData[playersLabel] as? [String],
              !readyPlayers.contains(playerId) else {
            return
        }

        matchData[playersLabel] = (readyPlayers + [playerId])
        matchData[countLabel] = (matchData[countLabel] as? Int ?? 0) + 1

        transaction.setData(matchData, forDocument: matchRef)
    }

    func removePlayerFromMatch(playerId: String, matchId: String) async {
        let matchRef = matches.document(matchId)
        do {
            _ = try await Firestore.firestore().runTransaction({ [weak self] (transaction, errorPointer) -> Any? in
                do {
                    guard let self = self else {
                        return nil
                    }
                    let matchDocument = try transaction.getDocument(matchRef)
                    guard var matchData = matchDocument.data(),
                          var readyPlayers = matchData[self.playersLabel] as? [String] else {
                        return nil
                    }
                    if let index = readyPlayers.firstIndex(of: playerId) {
                        readyPlayers.remove(at: index)
                    }
                    matchData[self.playersLabel] = readyPlayers
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

    func addListenerForAllMatches() -> MatchPublisher {
        let matchesListener = MatchListener()
        matchesListener.startListening()
        return matchesListener.getPublisher()
    }
}
