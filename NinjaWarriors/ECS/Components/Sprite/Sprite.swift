//
//  Sprite.swift
//  NinjaWarriors
//
//  Created by proglab on 23/3/24.
//

import Foundation
import SwiftUI
import UIKit

class Sprite: Component {
    var image: String
    var width: CGFloat
    var height: CGFloat

    init(id: ComponentID, entity: Entity, image: String, width: CGFloat, height: CGFloat) {
        self.image = image
        self.width = width
        self.height = height
        super.init(id: id, entity: entity)
    }

    override func updateAttributes(_ newSprite: Component) {
        guard let newSprite = newSprite as? Sprite else {
            return
        }
        self.image = newSprite.image
        self.width = newSprite.width
        self.height = newSprite.height
    }

    override func changeEntity(to entity: Entity) -> Component {
        Sprite(id: self.id, entity: entity, image: self.image, width: self.width, height: self.height)
    }

    override func wrapper() -> ComponentWrapper? {
        guard let entityWrapper = entity.wrapper() else {
            return nil
        }
        return SpriteWrapper(id: id, entity: entityWrapper, image: image, width: width,
                             height: height, wrapperType: NSStringFromClass(type(of: entityWrapper)))
    }
}
