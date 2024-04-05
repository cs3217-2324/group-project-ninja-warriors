//
//  ClosingZoneWrapper.swift
//  NinjaWarriors
//
//  Created by Jivesh Mohan on 5/4/24.
//

import Foundation

class ClosingZoneWrapper: EntityWrapper {

    override init(id: EntityID) {
        super.init(id: id)
    }

    required init(from decoder: Decoder) throws {
        try super.init(from: decoder)
    }

    override func toEntity() -> Entity? {
        return ClosingZone(id: id)
    }
}
