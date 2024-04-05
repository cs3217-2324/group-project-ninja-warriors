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
    var health: Int
    var maxHealth: Int

    var opacity: Double {
        return Double(health) / Double(maxHealth)
    }

    init(id: ComponentID, entity: Entity, image: String, width: CGFloat,
         height: CGFloat, health: Int, maxHealth: Int) {
        self.image = image
        self.width = width
        self.height = height
        self.health = health
        self.maxHealth = maxHealth
        super.init(id: id, entity: entity)
    }

    override func updateAttributes(_ newSprite: Component) {
        guard let newSprite = newSprite as? Sprite else {
            return
        }
        self.image = newSprite.image
        self.width = newSprite.width
        self.height = newSprite.height
        self.health = newSprite.health
        self.maxHealth = newSprite.maxHealth
    }
    
    override func wrapper() -> ComponentWrapper? {
        guard let entityWrapper = entity.wrapper() else {
            return nil
        }
        return SpriteWrapper(id: id, entity: entityWrapper, image: image, width: width, height: height, health: health, maxHealth: maxHealth)
    }
}
