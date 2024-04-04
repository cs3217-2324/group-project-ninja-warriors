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
    //TODO: remove hardcoded values, GameWorld should determine this
    @State private var circleCenter: CGPoint = CGPoint(x: 500, y: 500)
    @State private var circleRadius: CGFloat = 500
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    @State var timeRemaining = 60
    
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

            Text("\(timeRemaining)")
                .font(.largeTitle)
                .foregroundStyle(.white)
                .onReceive(timer) { _ in
                    timeRemaining = max(0, timeRemaining - 1)
                }.offset(CGSize(width: 0, height: -500))

            ClosingZone(circleCenter: $circleCenter, circleRadius: $circleRadius)

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
                            }, location: CGPoint(x: 150, y: geometry.size.height - 250))
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
