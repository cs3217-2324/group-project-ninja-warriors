//
//  MatchListener.swift
//  NinjaWarriors
//
//  Created by Muhammad Reyaaz on 16/3/24.
//

import Foundation

class MatchListener: FactoryListener<MatchPublisher, MatchWrapper> {
    init() {
        super.init(collectionName: "matches", publisher: MatchPublisher())
    }
}
