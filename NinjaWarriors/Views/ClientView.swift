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
    @State private var fixedEntities: [Entity]

    init(matchId: String, currPlayerId: String, fixedEntities: [Entity]) {
        self.matchId = matchId
        self.playerId = currPlayerId
        self.fixedEntities = fixedEntities
        self.viewModel = ClientViewModel(matchId: matchId, currPlayerId: currPlayerId,
                                         fixedEntities: fixedEntities)
    }

    var body: some View {
        ZStack {
            backgroundImage
            closingZoneView
            canvasView

            ProgressView("Loading...")
                .onAppear {
                    viewModel.gameWorld.entityComponentManager.intialPopulateWithCompletion {
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
                        viewModel.gameWorld.setInput(vector, for: currPlayer)
                    }, location: CGPoint(x: 150, y: geometry.size.height - 350))
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
            .zIndex(-1)
            .opacity(isShowingEntityOverlay ? 1 : 0)
        }
    }

    private var closingZoneView: some View {
        ClosingZoneView(circleCenter: viewModel.closingZoneCenter, circleRadius: viewModel.closingZoneRadius)
    }
}

struct ClientView_Previews: PreviewProvider {
    static var previews: some View {
        ClientView(matchId: "PqsMb1SDQbqRVHoQUpp6", currPlayerId: "lWgnfO6vrAZdeWa1aVThWzBLASr2", fixedEntities: [])
    }
}
