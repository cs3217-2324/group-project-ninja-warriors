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

    init(id: ComponentID, entity: Entity, isEnabled: Bool) {
        self.isEnabled = isEnabled
        super.init(id: id, entity: entity)
    }

    override func wrapper() -> ComponentWrapper? {
        guard let entityWrapper = entity.wrapper() else {
            return nil
        }
        return DodgeWrapper(id: id, entity: entityWrapper, isEnabled: isEnabled)
    }
}
