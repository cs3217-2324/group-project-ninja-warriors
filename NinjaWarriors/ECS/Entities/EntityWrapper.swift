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

    // TODO: FIX THIS
    func toEntity() -> Entity? { return FactoryEntity(id: id) }
}


class FactoryEntity: Equatable, Entity {
    let id: EntityID

    init(id: EntityID) {
        self.id = id
    }

    func getInitializingComponents() -> [Component] {
        return []
    }

    func deepCopy() -> Entity {
        FactoryEntity(id: id)
    }

    func wrapper() -> EntityWrapper? {
        FactoryTestWrapper(id: id)
    }

    static func == (lhs: FactoryEntity, rhs: FactoryEntity) -> Bool {
        lhs.id == rhs.id
    }
}

class FactoryTestWrapper: EntityWrapper {

    override init(id: EntityID) {
        super.init(id: id)
    }

    required init(from decoder: Decoder) throws {
        try super.init(from: decoder)
    }

    override func toEntity() -> Entity? {
        return FactoryEntity(id: id)
    }
}
