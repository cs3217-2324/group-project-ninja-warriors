//
//  HostView.swift
//  NinjaWarriors
//
//  Created by Muhammad Reyaaz on 15/3/24.
//

import Foundation
import SwiftUI

struct HostView: View {
    @ObservedObject var viewModel: HostViewModel
    @State private var isShowingEntityOverlay = false
    @State private var matchId: String
    @State private var playerId: String
    @State private var mapBackground: String

    init(matchId: String, currPlayerId: String, ownEntities: [Entity], mapBackground: String, gameMode: GameMode) {
        self.matchId = matchId
        self.playerId = currPlayerId
        self.mapBackground = mapBackground
        self.viewModel = HostViewModel(matchId: matchId, currPlayerId: currPlayerId, ownEntities: ownEntities, gameMode: gameMode)
    }

    var body: some View {
        ZStack {
            backgroundImage
            closingZoneView
            canvasView

            ProgressView()
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
        Image(mapBackground)
            .resizable()
            .edgesIgnoringSafeArea(.all)
            .statusBar(hidden: true)
    }

    private var canvasView: some View {
        GeometryReader { geometry in
            ForEach(Array(viewModel.entities.enumerated()), id: \.element.id) { _, entity in
                    EntityView(viewModel: EntityViewModel(components: viewModel.getComponents(for: entity), currPlayerId: viewModel.currPlayerId))
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

struct HostView_Previews: PreviewProvider {
    static var previews: some View {
        HostView(matchId: "PqsMb1SDQbqRVHoQUpp6", currPlayerId: "lWgnfO6vrAZdeWa1aVThWzBLASr2",
                 ownEntities: [], mapBackground: "blue-wall", gameMode: LastManStandingMode())
    }
}
