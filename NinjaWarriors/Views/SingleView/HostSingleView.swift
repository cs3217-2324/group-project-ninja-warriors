//
//  HostSingleView.swift
//  NinjaWarriors
//
//  Created by Muhammad Reyaaz on 9/4/24.
//

import Foundation
import SwiftUI

struct HostSingleView: View {
    @ObservedObject var viewModel: HostSingleViewModel
    @State private var isShowingEntityOverlay = false
    @State private var matchId: String
    @State private var playerId: String
    @State private var mapBg: String

    init(matchId: String, currPlayerId: String, mapBg: String) {
        self.matchId = matchId
        self.playerId = currPlayerId
        self.mapBg = mapBg
        self.viewModel = HostSingleViewModel(matchId: matchId, currPlayerId: currPlayerId)
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
        Image(mapBg)
            .resizable()
            .edgesIgnoringSafeArea(.all)
            .statusBar(hidden: true)
    }

    private var canvasView: some View {
        GeometryReader { geometry in
            ForEach(Array(viewModel.entities.enumerated()), id: \.element.id) { _, entity in
                EntityView(viewModel: EntityViewModel(components: viewModel.getComponents(for: entity),
                                                      currPlayerId: viewModel.currPlayerId))
            }
            if let currPlayer = viewModel.getCurrPlayer() {
                JoystickView(
                    setInputVector: { vector in
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

struct HostSingleView_Previews: PreviewProvider {
    static var previews: some View {
        HostSingleView(matchId: "PqsMb1SDQbqRVHoQUpp6", currPlayerId: "lWgnfO6vrAZdeWa1aVThWzBLASr2",
                       mapBg: "blue-wall")
    }
}
