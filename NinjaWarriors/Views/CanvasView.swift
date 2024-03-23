//
//  CanvasView.swift
//  NinjaWarriors
//
//  Created by Muhammad Reyaaz on 15/3/24.
//

import Foundation
import SwiftUI

struct CanvasView: View {
    @ObservedObject var viewModel: CanvasViewModel
    @State private var isShowingEntityOverlay = false

    @State private var matchId: String
    @State private var joystickPosition: CGPoint = .zero
    @State private var playerPosition = CGPoint(x: 300.0, y: 300.0)

    init(matchId: String, currPlayerId: String) {
        self.matchId = matchId
        self.viewModel = CanvasViewModel(matchId: matchId, currPlayerId: currPlayerId)
    }

    var body: some View {
        ZStack {
            EntityOverlayView(entities: viewModel.entities,
                              componentManager: viewModel.gameWorld.entityComponentManager)
                .transition(.move(edge: .trailing))
                .animation(.default, value: isShowingEntityOverlay)
                .zIndex(1) // Ensure the overlay is above all other content
                .opacity(isShowingEntityOverlay ? 1 : 0)

            Button(action: {
                isShowingEntityOverlay.toggle()
            }, label: {
                Image(systemName: "eye")
                    .accessibilityLabel("Toggle Entity Overlay")
            })
            .padding()
            .background(Color.blue.opacity(0.7))
            .foregroundColor(.white)
            .clipShape(Circle())
            .padding([.top, .trailing])
            VStack {
                GeometryReader { geometry in
                    ZStack {
                        ForEach(viewModel.entities.compactMap { $0 }, id: \.id) { entity in
                            VStack {
                                Circle()
                                    .fill(Color.blue)
                                    .frame(width: 50, height: 50)
                                    .position(entity.shape.getCenter())
                                    .position(x: playerPosition.x,
                                              y: playerPosition.y)
                                Text("\(entity.id)")
                            }
                        }
                    }
                    HStack {
                        if viewModel.gameControl is JoystickControl {
                            JoystickView(
                                playerPosition: $playerPosition,
                                setInputVector: { vector in
                                    viewModel.changePosition(newPosition: playerPosition)
                                //viewModel.gameControl.setInputVector(vector)
                            }, location: CGPoint(x: 100, y: 100))
                            .background(Color.red)
                            .frame(width: 200, height: 200)
                            .offset(x: 20, y: Constants.screenHeight - 220)
                        }
                        Spacer()
                        ForEach(viewModel.getSkillIds(for: viewModel.currPlayerId), id: \.self) { skillId in
                            Button(action: {
                                viewModel.activateSkill(forEntityWithId: viewModel.currPlayerId, skillId: skillId)
                            }) {
                                Text("\(skillId)")
                            }
                            .padding()
                        }

                    }
                }
            }
            .onAppear {
                viewModel.addListeners()
            }
        }
    }
}

struct CanvasView_Previews: PreviewProvider {
    static var previews: some View {
        CanvasView(matchId: "SampleMatchID", currPlayerId: "SamplePlayerID")
    }
}
