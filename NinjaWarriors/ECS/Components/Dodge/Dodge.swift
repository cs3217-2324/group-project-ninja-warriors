//
//  Dodge.swift
//  NinjaWarriors
//
//  Created by Joshen on 1/4/24.
//

import Foundation
import SwiftUI

class Dodge: Component {
    var isEnabled: Bool
    var invulnerabilityDuration: TimeInterval
    var elapsedTimeSinceEnabled: CGFloat

    init(id: ComponentID, entity: Entity, isEnabled: Bool, invulnerabilityDuration: TimeInterval, elapsedTimeSinceEnabled: CGFloat = 0) {
        self.isEnabled = isEnabled
        self.invulnerabilityDuration = invulnerabilityDuration
        self.elapsedTimeSinceEnabled = elapsedTimeSinceEnabled
        super.init(id: id, entity: entity)
    }

    override func wrapper() -> ComponentWrapper? {
        guard let entityWrapper = entity.wrapper() else {
            return nil
        }
        return DodgeWrapper(id: id, entity: entityWrapper, isEnabled: isEnabled, invulnerabilityDuration: invulnerabilityDuration, elapsedTimeSinceEnabled: elapsedTimeSinceEnabled)
    }
}
