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
            Image("gray-wall")
                .resizable()
                .edgesIgnoringSafeArea(.all)
                .statusBar(hidden: true)
            ZStack {
                GeometryReader { geometry in
                    ZStack {
                        ForEach(Array(viewModel.entities.enumerated()), id: \.element.id) { index, entity in
                            Text("\(viewModel.entities.count)")
                            //Image("player-icon")
                            
                            if let (render, pos) = viewModel.test(for: entity) {
                                render
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: 50, height: 50)
                                    .position(pos)
                                    .animation(.easeOut(duration: 0.2))
                            }
                        }

                        /*
                        ForEach(Array(viewModel.entities.enumerated()), id: \.element.id) { index, entity in
                            if let (render, pos) = viewModel.entityHasRigidAndSprite(for: entity) {
                                render
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: 50, height: 50)
                                    .position(pos)
                                    .animation(.easeOut(duration: 0.2))
                            }
                        }
                        */
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
                    /*
                    EntityOverlayView(entities: viewModel.entities,
                                      componentManager: viewModel.gameWorld.entityComponentManager)
                    .zIndex(-1)
                    .opacity(isShowingEntityOverlay ? 1 : 0)
                    */
                }
            }
        }
        .onAppear {
            Timer.scheduledTimer(withTimeInterval: 1/60, repeats: true) { timer in
                Task {
                    let localViewModel = viewModel
                    do {
                        if let entity = localViewModel.getEntity(from: localViewModel.currPlayerId) {
                            try await localViewModel.manager.uploadEntity(entity: entity, components: localViewModel.entityComponents[localViewModel.currPlayerId])
                        }
                    } catch {
                        print("Error uploading entity: \(error)")
                    }
                }
            }
        }

    }
}

/*
 render
     .resizable()
     .aspectRatio(contentMode: .fill)
     .frame(width: 50, height: 50)
     .position(pos)
     .animation(.easeOut(duration: 0.2))
 */

    /*

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
                                    .animation(.easeOut(duration: 0.2))
                            }
                        }
                    }

                    if let currPlayer = viewModel.getCurrPlayer() {
                        JoystickView(
                            setInputVector: { vector in
                                //viewModel.setInput(vector, for: currPlayer)
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
                                      componentManager: viewModel.gameWorld.entityComponentManager)
                    //.zIndex(-1)
                    //.opacity(isShowingEntityOverlay ? 1 : 0)

                }
            }
        }
    }
}

struct ClientView_Previews: PreviewProvider {
    static var previews: some View {
        ClientView(matchId: "PqsMb1SDQbqRVHoQUpp6", currPlayerId: "lWgnfO6vrAZdeWa1aVThWzBLASr2")
    }
}
*/
