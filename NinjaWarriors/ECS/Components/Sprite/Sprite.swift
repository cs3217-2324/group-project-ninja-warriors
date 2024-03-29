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

    init(id: EntityID, entity: Entity, image: String, width: CGFloat,
         height: CGFloat, health: Int, maxHealth: Int) {
        self.image = image
        self.width = width
        self.height = height
        self.health = health
        self.maxHealth = maxHealth
        super.init(id: id, entity: entity)
    }

    func loadImage(completion: @escaping (Image?) -> Void) {
        guard let uiImage = UIImage(named: image) else {
            print("Error loading image named '\(image)' from asset catalog")
            completion(nil)
            return
        }
        let image = Image(uiImage: uiImage)
            .resizable()
            .frame(width: width, height: height)
            .opacity(opacity)

        completion(image as? Image)
    }

    override func wrapper() -> ComponentWrapper? {
        guard let entityWrapper = entity.wrapper() else {
            return nil
        }
        return SpriteWrapper(id: id, entity: entityWrapper, image: image, width: width, height: height, health: health, maxHealth: maxHealth)
    }
}
