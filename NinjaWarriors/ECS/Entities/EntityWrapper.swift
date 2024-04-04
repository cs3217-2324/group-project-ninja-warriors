//
//  EntityWrapper.swift
//  NinjaWarriors
//
//  Created by Muhammad Reyaaz on 21/3/24.
//

import Foundation

class EntityWrapper: FactoryWrapper {
    typealias Item = EntityWrapper

    var id: EntityID

    init(id: EntityID) {
        self.id = id
    }

    open func toEntity() -> Entity? {
        //return nil
        Obstacle(id: "1")
    }
}

/*
protocol EntityWrapper: Codable {
    func toEntity() -> Entity?
}
*/
