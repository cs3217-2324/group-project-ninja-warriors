//
//  EntityView.swift
//  NinjaWarriors
//
//  Created by Joshen on 7/4/24.
//

import Foundation
import SwiftUI

struct EntityView: View {
    @ObservedObject var viewModel: EntityViewModel

    var body: some View {
        ZStack {
            if let sprite = viewModel.sprite {
                image(for: sprite)
            }
            if let health = viewModel.health, let sprite = viewModel.sprite {
                healthBar(for: health, width: sprite.width)
            }
        }
    }

    private func image(for sprite: Sprite) -> some View {
        Image(sprite.image)
            .resizable()
            .aspectRatio(contentMode: .fill)
            .frame(width: sprite.width, height: sprite.height)
            .position(viewModel.position)
            .opacity(viewModel.opacity)
    }

    private func healthBar(for health: Health, width: CGFloat) -> some View {
        let healthBarWidth = width
        let healthPercentage = CGFloat(health.health) / CGFloat(health.maxHealth)
        let healthBarFillWidth = healthBarWidth * healthPercentage
        var healthBarOffsetY = Constants.HealthBar.offsetY
        
        if let sprite = viewModel.sprite {
            healthBarOffsetY += sprite.height / 2
        }
        
        return ZStack(alignment: .leading) {
            Rectangle()
                .fill(Color.red)
                .frame(width: healthBarWidth, height: Constants.HealthBar.height)
                .position(x: viewModel.position.x, y: viewModel.position.y - healthBarOffsetY)
            Rectangle()
                .fill(Color.green)
                .frame(width: healthBarFillWidth, height: Constants.HealthBar.height)
                .position(x: viewModel.position.x - healthBarWidth / 2 + healthBarFillWidth / 2, y: viewModel.position.y - healthBarOffsetY)
        }
    }
}

struct EntityView_Previews: PreviewProvider {
    static var previews: some View {
        let player = Player(id: "player1", position: Point(xCoord: 400, yCoord: 400))
        
        let components = player.getInitializingComponents()

        // mock SlashAOE
        let slashaoe = SlashAOE(id: RandomNonce().randomNonceString(), casterEntity: player)
        let sprite = Sprite(id: RandomNonce().randomNonceString(),
                            entity: slashaoe,
                            image: "slash-effect", width: 100, height: 100, health: 10, maxHealth: 100)
        let rigidbody = Rigidbody(id: RandomNonce().randomNonceString(), entity: slashaoe,
                                  angularDrag: 0, angularVelocity: 0, mass: 8,
                                  rotation: 0, totalForce: Vector.zero, inertia: 0,
                                  position: Point(xCoord: 400, yCoord: 400), velocity: Vector.zero)
        let lifespan = Lifespan(id: RandomNonce().randomNonceString(), entity: slashaoe, lifespan: 1, elapsedTime: 0.8)
        
        EntityView(viewModel: EntityViewModel(components: [sprite, rigidbody, lifespan]))
            .previewLayout(.sizeThatFits)
            .padding()
            .background(Color.black)
        
        EntityView(viewModel: EntityViewModel(components: components))
            .previewLayout(.sizeThatFits)
            .padding()
        
    }
}

