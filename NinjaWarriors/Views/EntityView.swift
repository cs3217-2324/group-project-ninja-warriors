//
//  EntityView.swift
//  NinjaWarriors
//
//  Created by Joshen on 7/4/24.
//

import Foundation
import SwiftUI

struct EntityView: View {
    let sprite: Sprite
    let position: CGPoint
    let health: Health?

    var body: some View {
        ZStack {
            image
            healthBar
        }
    }
    
    private var image: some View {
        Image(sprite.image)
            .resizable()
            .aspectRatio(contentMode: .fill)
            .frame(width: sprite.width, height: sprite.height)
            .position(position)
            .animation(.easeOut(duration: 0.2))
    }
    
    private var healthBar: some View {
        Group {
            if let health = health {
                let healthBarWidth = sprite.width
                let healthPercentage = health.health / health.maxHealth
                let healthBarFillWidth = healthBarWidth * CGFloat(healthPercentage)

                ZStack(alignment: .leading) {
                    Rectangle()
                        .fill(Color.red)
                        .frame(width: healthBarWidth, height: Constants.HealthBar.height)
                        .position(x: position.x, y: position.y - sprite.height / 2 - Constants.HealthBar.offsetY)
                    Rectangle()
                        .fill(Color.green)
                        .frame(width: healthBarFillWidth, height: Constants.HealthBar.height)
                        .position(x: position.x - healthBarWidth / 2 + healthBarFillWidth / 2, y: position.y - sprite.height / 2 - Constants.HealthBar.offsetY)
                }
            }
        }
    }
}
