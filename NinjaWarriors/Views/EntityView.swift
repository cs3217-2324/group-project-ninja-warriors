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
            dodgeImage
            if let health = viewModel.health, let sprite = viewModel.sprite, !(health.entity is Gem) {
                healthBar(for: health, width: sprite.width)
            }
        }
    }

    private var dodgeImage: some View {
        Group {
            if let dodge = viewModel.dodge {
                Group {
                    Image(Constants.DodgeImage.image)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .colorMultiply(.purple)
                }
                .opacity(dodge.isEnabled ? 0.8 : 0)
                .scaleEffect(dodge.isEnabled ? 1.0 : 0, anchor: .center)
                .animation(dodge.isEnabled ?
                    .spring(response: 0.5, dampingFraction: 0.6, blendDuration: 0) :
                        .easeInOut(duration: 0.1), value: dodge.isEnabled)
            }
        }
        .frame(width: Constants.DodgeImage.width, height: Constants.DodgeImage.height)
        .position(viewModel.position)
    }

    private func image(for sprite: Sprite) -> some View {
        Group {
            Image(sprite.image)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .opacity(viewModel.opacity)
                .rotationEffect(Angle(degrees: viewModel.rotation))
                .frame(width: sprite.width, height: sprite.height)
                .position(viewModel.position)
                .overlay(
                    overlay(for: sprite, isCurrentUser: sprite.entity.id == viewModel.currPlayerId)
                )
        }
    }

    private func overlay(for sprite: Sprite, isCurrentUser: Bool) -> some View {
        let text = isCurrentUser ? "YOU" : "ENEMY"
        let color = isCurrentUser ? Color.blue : Color.red

        return GeometryReader { _ in
            if sprite.entity is Player {
                Text(text)
                    .foregroundColor(color)
                    .fontWeight(.bold)
                    .font(.system(size: 12))
                    .padding(4)
                    .cornerRadius(2)
                    .position(x: viewModel.position.x, y: viewModel.position.y - sprite.height / 2 - 35)
            }
        }
    }

    private func healthBar(for health: Health, width: CGFloat) -> some View {
        let healthBarWidth = width
        let healthPercentage = CGFloat(health.health) / CGFloat(health.maxHealth)
        let healthBarFillWidth = max(healthBarWidth * healthPercentage, 0)
        var healthBarOffsetY = Constants.HealthBar.offsetY

        if let sprite = viewModel.sprite {
            healthBarOffsetY += sprite.height / 2
        }

        var healthColor = Color.green

        if let dodge = viewModel.dodge, dodge.isEnabled {
            healthColor = Color.yellow
        }

        return ZStack(alignment: .leading) {
            Rectangle()
                .fill(Color.red)
                .border(/*@START_MENU_TOKEN@*/Color.black/*@END_MENU_TOKEN@*/)
                .frame(width: healthBarWidth, height: Constants.HealthBar.height)
                .position(x: viewModel.position.x, y: viewModel.position.y - healthBarOffsetY)

            Rectangle()
                .fill(healthColor)
                .border(/*@START_MENU_TOKEN@*/Color.black/*@END_MENU_TOKEN@*/)
                .frame(width: max(healthBarFillWidth, 0), height: Constants.HealthBar.height)
                .position(x: viewModel.position.x - healthBarWidth / 2 + healthBarFillWidth / 2,
                          y: viewModel.position.y - healthBarOffsetY)
        }
    }
}

struct EntityView_Previews: PreviewProvider {
    static var previews: some View {
        let player = Player(id: "player1", position: Point(xCoord: 400, yCoord: 400))

        let components = player.getMockComponents()

        // mock SlashAOE
        let slashaoe = SlashAOE(id: RandomNonce().randomNonceString(), casterEntity: player)
        let sprite = Sprite(id: RandomNonce().randomNonceString(),
                            entity: slashaoe,
                            image: "slash-effect", width: 100, height: 100)
        let rigidbody = Rigidbody(id: RandomNonce().randomNonceString(), entity: slashaoe,
                                  angularDrag: 0, angularVelocity: Vector.zero, mass: 8,
                                  rotation: 0, totalForce: Vector.zero, inertia: 0,
                                  position: Point(xCoord: 400, yCoord: 400), velocity: Vector.zero)
        let lifespan = Lifespan(id: RandomNonce().randomNonceString(), entity: slashaoe, lifespan: 1, elapsedTime: 0.8)

        EntityView(viewModel: EntityViewModel(components: [sprite, rigidbody, lifespan],
                                              currPlayerId: "player"))
            .previewLayout(.sizeThatFits)
            .padding()
            .background(Color.black)

        EntityView(viewModel: EntityViewModel(components: components, currPlayerId: "player"))
            .previewLayout(.sizeThatFits)
            .padding()

    }
}
