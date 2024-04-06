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
    @State private var isInitialized = false

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

            if isInitialized {
                Text("\(viewModel.entities.count)")
                    .font(.title) // Increase the size
                    .foregroundColor(.blue) // Make it red
            } else {
                ProgressView("Loading...")
                    .onAppear {
                        // Call initialPopulate() here
                        viewModel.entityComponentManager.intialPopulateWithCompletion {
                            // This closure is called when initialPopulate completes
                            // Update the state to show the main view
                            viewModel.test()
                            isInitialized = true
                        }
                    }
            }


            ZStack {
                GeometryReader { geometry in
                    ZStack {
                        ForEach(Array(viewModel.entities.enumerated()), id: \.element.id) { index, entity in


                            Text("\(viewModel.entities.count)")
                                .font(.title) // Increase the size
                                .foregroundColor(.red) // Make it red

                            //Image("player-icon")

                            if let (render, pos) = viewModel.render(for: entity) {
                                render
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: 50, height: 50)
                                    .position(pos)
                                    .animation(.easeOut(duration: 0.2))
                            } else {
                                Text("Hello!!!")
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
            viewModel.entityComponentManager.initialPopulate()
            viewModel.updateEntities()
        }
        /*
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
        */
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


struct ClientView_Previews: PreviewProvider {
    static var previews: some View {
        ClientView(matchId: "5NjVOKbhQrXDnlcmeVpE", currPlayerId: "lWgnfO6vrAZdeWa1aVThWzBLASr2")
    }
}
