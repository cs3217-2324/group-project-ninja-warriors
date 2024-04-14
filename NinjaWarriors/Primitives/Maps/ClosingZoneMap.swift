//
//  ClosingZoneMap.swift
//  NinjaWarriors
//
//  Created by Muhammad Reyaaz on 11/4/24.
//

import Foundation

class ClosingZoneMap: Map {
    internal let mapBg = "brown-wall"
    internal var mapEntities: [Entity] = []

    func getPositions() -> [Point] {
        [Constants.closingZonePosition]
    }

    func getMapEntities() -> [Entity] {
        let positions: [Point] = getPositions()

        for index in 0..<1 {
            let closingZone = ClosingZone(id: RandomNonce().randomNonceString(),
                                          center: positions[index],
                                          initialRadius: Constants.closingZoneRadius)
            mapEntities.append(closingZone)
        }
        return mapEntities
    }
}
