//
//  LobbyView.swift
//  NinjaWarriors
//
//  Created by Muhammad Reyaaz on 16/3/24.
//

import Foundation
import SwiftUI

struct LobbyView: View {
    @EnvironmentObject var signInViewModel: SignInViewModel
    @State private var isReady: Bool = false
    @ObservedObject var viewModel: LobbyViewModel
    @Binding var path: NavigationPath

    init(path: Binding<NavigationPath>) {
        self.viewModel = LobbyViewModel()
        self._path = path
    }

    init(viewModel: LobbyViewModel, path: Binding<NavigationPath>) {
        self.viewModel = viewModel
        self._path = path
    }

    var body: some View {
        VStack(spacing: 10) {
            userLoginInfo
            if let playerCount = viewModel.getPlayerCount() {

                customText("Players in queue: \(playerCount) / \(Constants.playerCount)")

                if playerCount == Constants.playerCount {

                    startRender

                    if let matchId = viewModel.matchId, viewModel.playerIds != nil {

                        customText("Match id: \(matchId)")

                        if viewModel.getUserId() == viewModel.hostId {
                            NavigationLink(
                                destination: HostView(matchId: matchId,
                                                      currPlayerId: viewModel.getUserId(),
                                                      ownEntities: viewModel.ownEntities,
                                                      mapBackground: viewModel.map.mapBackground,
                                                      metricsRepository: viewModel.metricsRepository,
                                                      achievementManager: viewModel.achievementsManager,
                                                      gameMode: viewModel.map.gameMode
                                                     ).navigationBarBackButtonHidden(true)
                            ) {
                                startGameText
                            }
                            .simultaneousGesture(TapGesture().onEnded {
                                AudioManager.shared.playButtonClickAudio()
                                AudioManager.shared.stopAll()
                            })
                        } else {
                            NavigationLink(
                                destination: ClientView(matchId: matchId,
                                                        currPlayerId: viewModel.getUserId(),
                                                        ownEntities: viewModel.ownEntities,
                                                        mapBackground: viewModel.map.mapBackground,
                                                        metricsRepository: viewModel.metricsRepository,
                                                        achievementManager: viewModel.achievementsManager,
                                                        gameMode: viewModel.map.gameMode
                                                       ).navigationBarBackButtonHidden(true)
                            ) {
                                startGameText
                            }
                            .simultaneousGesture(TapGesture().onEnded {
                                AudioManager.shared.playButtonClickAudio()
                                AudioManager.shared.stopAll()
                            })
                        }
                    }
                }
            }
            readyButton

            NavigationLink(destination: MapSelectionView(viewModel: viewModel)) {
                Text("Select Map")
                    .font(.system(size: 30))
                    .padding()
                    .background(Color.purple)
                    .foregroundColor(.white)
                    .fontWeight(.bold)
                    .cornerRadius(10)
            }
            .simultaneousGesture(TapGesture().onEnded {
                AudioManager.shared.playButtonClickAudio()
            })
            .opacity(isReady ? 0.5 : 1.0)
            .disabled(isReady)

            NavigationLink(destination: CharacterSelectionView(viewModel: viewModel)) {
                Text("Select Character")
                    .font(.system(size: 30))
                    .padding()
                    .background(Color.purple)
                    .foregroundColor(.white)
                    .fontWeight(.bold)
                    .cornerRadius(10)
            }
            .simultaneousGesture(TapGesture().onEnded {
                AudioManager.shared.playButtonClickAudio()
            })
            .opacity(isReady ? 0.5 : 1.0)
            .disabled(isReady)

            NavigationLink(destination: AchievementsView(achievementManager: viewModel.achievementsManager)) {
                Text("View Achievements")
                    .font(.system(size: 20))
                    .padding()
                    .background(.pink)
                    .foregroundColor(.white)
                    .fontWeight(.bold)
                    .cornerRadius(10)
            }.padding(.top, 100)
        }
        .background(
            Image("lobby-bg")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .edgesIgnoringSafeArea(.all)
                .frame(width: Constants.screenWidth, height: Constants.screenHeight)
        )
    }

    private var userLoginInfo: some View {
        Group {
            if !viewModel.isGuest, let user = signInViewModel.user {
                customText("UID: \(user.uid)")
                customText("Email: \(user.email ?? "N/A")")
            }
        }
    }

    private var readyButton: some View {
        Button(action: {
            viewModel.ready(userId: (viewModel.isGuest ? viewModel.guestId : signInViewModel.getUserId()) ?? "none")
            isReady = true
        }) {
            Text("Ready")
                .font(.system(size: 30))
                .padding()
                .background(Color.purple)
                .foregroundColor(.white)
                .fontWeight(.bold)
                .cornerRadius(10)
        }
        .padding()
        .opacity(isReady ? 0 : 1)
        .disabled(isReady)
    }

    private var startRender: some View {
        Text("")
            .hidden()
            .onAppear {
                Task {
                    await viewModel.start()
                }
            }
    }

    private var startGameText: some View {
        Text("Start")
            .font(.system(size: 30))
            .padding()
            .background(Color.purple)
            .foregroundColor(.white)
            .fontWeight(.bold)
            .cornerRadius(10)
    }

    private func customText(_ data: String) -> some View {
        Text(data)
            .font(.system(size: 20))
            .fontWeight(.bold)
            .foregroundColor(Color(red: 0.8, green: 0.8, blue: 0.8))
    }
}
