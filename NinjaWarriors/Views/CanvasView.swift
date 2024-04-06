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
    @State private var playerId: String

    var closingZoneCenter: CGPoint {
        viewModel.closingZone()?.center ?? .zero
    }
    var closingZoneRadius: CGFloat {
        viewModel.closingZone()?.radius ?? 0
    }

    init(matchId: String, currPlayerId: String) {
        self.matchId = matchId
        self.playerId = currPlayerId
        self.viewModel = CanvasViewModel(matchId: matchId, currPlayerId: currPlayerId)
    }

    var body: some View {
        ZStack {
            Image("gray-wall")
                .resizable()
                .edgesIgnoringSafeArea(.all)
                .statusBar(hidden: true)

            ClosingZoneView(circleCenter: closingZoneCenter, circleRadius: closingZoneRadius)

            ZStack {
                GeometryReader { geometry in
                    ZStack {
                        ForEach(Array(viewModel.entities.enumerated()), id: \.element.id) { index, entity in
                            if let (render, pos) = viewModel.entityHasRigidAndSprite(for: entity) {
                                render
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: 50, height: 50)
                                    .position(pos)
                            }
                        }
                    }

                    if let currPlayer = viewModel.getCurrPlayer() {
                        JoystickView(
                            setInputVector: { vector in
                                viewModel.gameWorld.setInput(vector, for: currPlayer)
                            }, location: CGPoint(x: 150, y: geometry.size.height - 300))
                        .frame(width: 200, height: 200)
                        VStack {
                            Spacer()
                            PlayerControlsView(
                                skills: viewModel.getSkills(for: currPlayer),
                                toggleEntityOverlay: {
                                    isShowingEntityOverlay.toggle()
                                },
                                activateSkill: { skillId in
                                    viewModel.activateSkill(forEntity: currPlayer, skillId: skillId)
                                }
                            )
                        }
                    }
                    EntityOverlayView(entities: viewModel.entities,
                                      componentManager: viewModel.gameWorld.entityComponentManager)
                    .zIndex(-1)
                    .opacity(isShowingEntityOverlay ? 1 : 0)

                }
                .onAppear {
                    viewModel.gameWorld.entityComponentManager.initialPopulate()
                    viewModel.updateEntities()
                }
            }
        }
    }
}

struct CanvasView_Previews: PreviewProvider {
    static var previews: some View {
        CanvasView(matchId: "PqsMb1SDQbqRVHoQUpp6", currPlayerId: "lWgnfO6vrAZdeWa1aVThWzBLASr2")
    }
}
