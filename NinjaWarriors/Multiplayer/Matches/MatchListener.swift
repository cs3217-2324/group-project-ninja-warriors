//
//  MatchListener.swift
//  NinjaWarriors
//
//  Created by Muhammad Reyaaz on 16/3/24.
//

import Foundation

class MatchListener: FactoryListener<MatchPublisher, MatchWrapper> {
    private let collectionName = "matches"
    init() {
        super.init(collectionName: collectionName, publisher: MatchPublisher())
    }
}
