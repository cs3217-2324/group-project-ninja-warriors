//
//  HadoukenWrapper.swift
//  NinjaWarriors
//
//  Created by Joshen on 15/4/24.
//

import Foundation

class HadoukenWrapper: EntityWrapper {
    var casterEntity: EntityWrapper = PlayerWrapper(id: RandomNonce().randomNonceString())

    init(id: EntityID, casterEntity: EntityWrapper) {
        super.init(id: id)
        self.casterEntity = casterEntity
    }

    required init(from decoder: Decoder) throws {
        try super.init(from: decoder)
    }

    override func toEntity() -> Entity? {
        guard let casterEntity = casterEntity.toEntity() else {
            return nil
        }
        return Hadouken(id: id, casterEntity: casterEntity)
    }
}
