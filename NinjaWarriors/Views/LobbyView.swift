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

    init() {
        self.viewModel = LobbyViewModel()
    }

    init(viewModel: LobbyViewModel) {
        self.viewModel = viewModel
    }

    var body: some View {
        NavigationView {
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
                                                          mapBg: viewModel.map.mapBg,
                                                          metricsRepository: viewModel.metricsRepository,
                                                          achievementManager: viewModel.achievementsManager
                                                         ).navigationBarBackButtonHidden(true)
                                ) {
                                    startGameText
                                }
                                .simultaneousGesture(TapGesture().onEnded {
                                    AudioManager.shared.playButtonClickAudio()
                                })
                            } else {
                                NavigationLink(
                                    destination: ClientView(matchId: matchId,
                                                            currPlayerId: viewModel.getUserId(),
                                                            ownEntities: viewModel.ownEntities,
                                                            mapBg: viewModel.map.mapBg,
                                                            metricsRepository: viewModel.metricsRepository,
                                                            achievementManager: viewModel.achievementsManager
                                                           ).navigationBarBackButtonHidden(true)
                                ) {
                                    startGameText
                                }
                                .simultaneousGesture(TapGesture().onEnded {
                                    AudioManager.shared.playButtonClickAudio()
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
            }
            .background(
                Image("lobby-bg")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .edgesIgnoringSafeArea(.all)
                    .frame(width: Constants.screenWidth, height: Constants.screenHeight)
            )
        }.navigationViewStyle(.stack)
        .navigationBarBackButtonHidden(true)
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
