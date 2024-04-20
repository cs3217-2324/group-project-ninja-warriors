//
//  SingleLobbyView.swift
//  NinjaWarriors
//
//  Created by Muhammad Reyaaz on 9/4/24.
//

import Foundation
import SwiftUI

struct SingleLobbyView: View {
    @State private var isReady: Bool = false
    @ObservedObject var viewModel = SingleLobbyViewModel()
    @Binding var path: NavigationPath

    var body: some View {
        VStack(spacing: 10) {
            readyButton
            if isReady {
                NavigationLink(
                    destination: HostSingleView(matchId: viewModel.matchId,
                                                currPlayerId: viewModel.hostId,
                                                mapBackground: viewModel.map.mapBackground,
                                                gameMode: viewModel.map.gameMode,
                                                metricsRepository: viewModel.metricsRepository,
                                                achievementManager: viewModel.achievementsManager,
                                                path: $path)
                    .navigationBarBackButtonHidden(true)) {
                        Text("Start")
                            .font(.custom("KARASHA", size: 30))
                            .padding()
                            .frame(width: 322, height: 96)
                            .background(Image("button-bg"))
                            .foregroundColor(.white)
                            .fontWeight(.bold)
                            .cornerRadius(10)
                    }
                    .simultaneousGesture(TapGesture().onEnded {
                        AudioManager.shared.playButtonClickAudio()
                        AudioManager.shared.stopAll()
                    })
            }

            NavigationLink(destination: MapSelectionView(viewModel: viewModel)) {
                Text("Select Map")
                    .font(.custom("KARASHA", size: 30))
                    .padding()
                    .frame(width: 322, height: 96)
                    .background(Image("button-bg"))
                    .foregroundColor(.white)
                    .fontWeight(.bold)
                    .cornerRadius(10)
            }
            .opacity(isReady ? 0.5 : 1.0)
            .disabled(isReady)
            .simultaneousGesture(TapGesture().onEnded {
                AudioManager.shared.playButtonClickAudio()
            })

            NavigationLink(destination: CharacterSelectionView(viewModel: viewModel)) {
                Text("Select Character")
                    .font(.custom("KARASHA", size: 30))
                    .padding()
                    .frame(width: 322, height: 96)
                    .background(Image("button-bg"))
                    .foregroundColor(.white)
                    .fontWeight(.bold)
                    .cornerRadius(10)
            }
            .opacity(isReady ? 0.5 : 1.0)
            .disabled(isReady)
            .simultaneousGesture(TapGesture().onEnded {
                AudioManager.shared.playButtonClickAudio()
            })
        }
        .background(
            Image("lobby-bg")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .edgesIgnoringSafeArea(.all)
                .frame(width: Constants.screenWidth, height: Constants.screenHeight)
        )
    }

    private var readyButton: some View {
        Button(action: {
            isReady = true
            viewModel.start()
        }) {
            Text("Ready")
                .font(.custom("KARASHA", size: 30))
                .padding()
                .frame(width: 322, height: 96)
                .background(Image("button-bg"))
                .foregroundColor(.white)
                .fontWeight(.bold)
                .cornerRadius(10)
        }
        .padding()
        .opacity(isReady ? 0 : 1)
        .disabled(isReady)
        .simultaneousGesture(TapGesture().onEnded {
            AudioManager.shared.playButtonClickAudio()
        })
    }
}
