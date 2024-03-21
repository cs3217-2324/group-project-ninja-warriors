//
//  PlayersListener.swift
//  NinjaWarriors
//
//  Created by Muhammad Reyaaz on 16/3/24.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

// TODO: Change realtime database to "entity" instead of "players"
class PlayersListener: RealTimeFactoryListener<EntityPublisher, PlayerWrapper> {
    init(matchId: String) {
        super.init(referenceName: matchId, publisher: EntityPublisher())
    }
}
