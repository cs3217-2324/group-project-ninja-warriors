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
    @State private var isHost: Bool

    init(matchId: String, currPlayerId: String, isHost: Bool) {
        self.matchId = matchId
        self.playerId = currPlayerId

        if isHost {
            viewModel = CanvasViewModel(matchId: matchId, currPlayerId: currPlayerId)
        } else {
            viewModel = CanvasViewModel(matchId: matchId, currPlayerId: currPlayerId)
        }

        self.isHost = isHost
    }

    var body: some View {
        ZStack {
            backgroundImage
            canvasView
        }
        .onAppear {
            viewModel.gameWorld.entityComponentManager.initialPopulate()
            viewModel.updateEntities()
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
                        viewModel.gameWorld.setInput(vector, for: currPlayer)
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
            .zIndex(-1)
            .opacity(isShowingEntityOverlay ? 1 : 0)
        }
    }
}

struct CanvasView_Previews: PreviewProvider {
    static var previews: some View {
        CanvasView(matchId: "PqsMb1SDQbqRVHoQUpp6", currPlayerId: "lWgnfO6vrAZdeWa1aVThWzBLASr2",
                   isHost: true)
    }
}
