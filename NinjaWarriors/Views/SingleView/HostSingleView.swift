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
    @State private var mapBackground: String
    @Binding var path: NavigationPath

    init(matchId: String, currPlayerId: String, mapBackground: String, achievementManager: AchievementManager, gameMode: GameMode, path: Binding<NavigationPath>) {
        self._matchId = State(initialValue: matchId)
        self._playerId = State(initialValue: currPlayerId)
        self._mapBackground = State(initialValue: mapBackground)
        let metricsRepository = MetricsRepository()
        self.viewModel = HostSingleViewModel(matchId: matchId,
                                             currPlayerId: currPlayerId,
                                             metricsRepository: metricsRepository,
                                             achievementManager: achievementManager,
                                             gameMode: gameMode)
        self._path = path
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
        Image(mapBackground)
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
