//
//  ClientView.swift
//  NinjaWarriors
//
//  Created by Muhammad Reyaaz on 6/4/24.
//

import Foundation
import SwiftUI

struct ClientView: View {
    @ObservedObject var viewModel: ClientViewModel
    @State private var isShowingEntityOverlay = false
    @State private var matchId: String
    @State private var playerId: String

    init(matchId: String, currPlayerId: String) {
        self.matchId = matchId
        self.playerId = currPlayerId
        self.viewModel = ClientViewModel(matchId: matchId, currPlayerId: currPlayerId)
    }


    var body: some View {
        ZStack {
            backgroundImage
            closingZoneView
            canvasView

            ProgressView("Loading...")
                .onAppear {
                    viewModel.entityComponentManager.intialPopulateWithCompletion {
                        DispatchQueue.main.async {
                            viewModel.updateEntities()
                        }
                    }
                }
        }
    }


    private var backgroundImage: some View {
        Image("gray-wall")
            .resizable()
            .edgesIgnoringSafeArea(.all)
            .statusBar(hidden: true)
    }

    private var canvasView: some View {
        GeometryReader { geometry in
            ForEach(Array(viewModel.entities.enumerated()), id: \.element.id) { index, entity in
                EntityView(viewModel: EntityViewModel(components: viewModel.getComponents(for: entity)))
            }
            if let currPlayer = viewModel.getCurrPlayer() {
                JoystickView(
                    setInputVector: { vector in
                        viewModel.move(vector)
                    }, location: CGPoint(x: 150, y: geometry.size.height - 300))
                .frame(width: 200, height: 200)
                VStack {
                    Spacer()
                    PlayerControlsView(
                        skills: viewModel.getSkills(for: currPlayer),
                        skillCooldowns: viewModel.getSkillCooldowns(for: currPlayer),
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
                              componentManager: viewModel.entityComponentManager)
            .zIndex(-1)
            .opacity(isShowingEntityOverlay ? 1 : 0)
        }
    }

    private var closingZoneView: some View {
        ClosingZoneView(circleCenter: viewModel.closingZoneCenter, circleRadius: viewModel.closingZoneRadius)
    }



    /*
    var body: some View {
        ZStack {
            Image("gray-wall")
                .resizable()
                .edgesIgnoringSafeArea(.all)
                .statusBar(hidden: true)

            ClosingZoneView(circleCenter: viewModel.closingZoneCenter, circleRadius: viewModel.closingZoneRadius)

            ProgressView("Loading...")
                .onAppear {
                    viewModel.entityComponentManager.intialPopulateWithCompletion {
                        DispatchQueue.main.async {
                            viewModel.updateEntities()
                        }
                    }
                }

            ZStack {
                GeometryReader { geometry in
                    ZStack {
                        ForEach(Array(viewModel.entities.enumerated()), id: \.element.id) { index, entity in
                            if let (render, pos) = viewModel.render(for: entity) {
                                render
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: 50, height: 50)
                                    .position(pos)
                                    .animation(.easeOut(duration: 0.2))
                            }
                        }
                    }

                    if let currPlayer = viewModel.getCurrPlayer() {
                        JoystickView(
                            setInputVector: { vector in
                                viewModel.move(vector)
                            }, location: CGPoint(x: 150, y: geometry.size.height - 300))
                        .frame(width: 200, height: 200)
                        VStack {
                            Spacer()
                            PlayerControlsView(
                                skills: viewModel.getSkills(for: currPlayer),
                                skillCooldowns: viewModel.getSkillCooldowns(for: currPlayer),
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
                                      componentManager: viewModel.entityComponentManager)
                    .zIndex(-1)
                    .opacity(isShowingEntityOverlay ? 1 : 0)
                }
            }
        }
    }
    */
}

struct ClientView_Previews: PreviewProvider {
    static var previews: some View {
        ClientView(matchId: "5NjVOKbhQrXDnlcmeVpE", currPlayerId: "lWgnfO6vrAZdeWa1aVThWzBLASr2")
    }
}
