//
//  ComponentWrapper.swift
//  NinjaWarriors
//
//  Created by Muhammad Reyaaz on 21/3/24.
//

import Foundation

protocol ComponentWrapper {
    func toComponent() -> Component?
}

/*
class ComponentWrapper: FactoryWrapper {
    typealias Item = ComponentWrapper

    var id: ComponentID
    unowned var entity: EntityWrapper?

    init(id: ComponentID, entity: EntityWrapper?) {
        self.id = id
        self.entity = entity
    }

    func toComponent() -> Component? {return nil }
}
*/
