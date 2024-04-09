//
//  PlayersListener.swift
//  NinjaWarriors
//
//  Created by Muhammad Reyaaz on 16/3/24.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

class PlayersListener: RealTimeFactoryListener<PlayerPublisher, PlayerWrapper> {
    init(matchId: String) {
        super.init(referenceName: matchId, publisher: PlayerPublisher(), entityName: "Player")
    }
}
