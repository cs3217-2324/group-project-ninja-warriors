//
//  DodgeWrapper.swift
//  NinjaWarriors
//
//  Created by Joshen on 1/4/24.
//

import Foundation

struct DodgeWrapper: ComponentWrapper {
    var id: ComponentID
    var entity: EntityWrapper
    var isEnabled: Bool

    func toComponent() -> Component? {
        guard let entity = entity.toEntity() else {
            return nil
        }
        return Dodge(id: id, entity: entity, isEnabled: isEnabled)
    }
}
