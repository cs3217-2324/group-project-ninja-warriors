//
//  ClosingZone.swift
//  NinjaWarriors
//
//  Created by Jivesh Mohan on 5/4/24.
//

import Foundation

class ClosingZone: Entity {
    let id: EntityID
    var center: Point = Point(xCoord: 400, yCoord: 400)
    var initialRadius: Double = 100

    init(id: EntityID) {
        self.id = id
    }

    convenience init(id: EntityID, center: Point, initialRadius: Double) {
        self.init(id: id)
        self.center = center
        self.initialRadius = initialRadius
    }

    func getInitializingComponents() -> [Component] {
        let shape = CircleShape(center: center, radius: initialRadius)
        
        let environmentEffect = EnvironmentEffect(id: RandomNonce().randomNonceString(), entity: self, environmentShape: shape, effectIsActiveInsideShape: true)

        return [environmentEffect]
    }

    func deepCopy() -> Entity {
        ClosingZone(id: id, center: center, initialRadius: initialRadius)
    }

    func wrapper() -> EntityWrapper? {
        return ClosingZoneWrapper(id: id)
    }
}
