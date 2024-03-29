//
//  SpriteWrapper.swift
//  NinjaWarriors
//
//  Created by Muhammad Reyaaz on 28/3/24.
//

import Foundation


struct SpriteWrapper: ComponentWrapper {
    var id: EntityID
    var entity: EntityWrapper
    var image: String
    var width: CGFloat
    var height: CGFloat
    var health: Int
    var maxHealth: Int

    func toComponent() -> Component? {
        guard let entity = entity.toEntity() else {
            return nil
        }
        return Sprite(id: id, entity: entity, image: image, width: width,
                      height: height, health: health, maxHealth: maxHealth)
    }
}
