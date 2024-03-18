//
//  PlayersListener.swift
//  NinjaWarriors
//
//  Created by Muhammad Reyaaz on 16/3/24.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

/*
class PlayersListener: FactoryListener<PlayerPublisher, PlayerWrapper> {
    init() {
        super.init(collectionName: "players", publisher: PlayerPublisher())
    }
}
*/

class PlayersListener: RealTimeFactoryListener<PlayerPublisher, PlayerWrapper> {
    init() {
        super.init(referenceName: "players", publisher: PlayerPublisher())
    }
}
