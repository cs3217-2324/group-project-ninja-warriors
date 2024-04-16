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
                                                path: $path)
                    .navigationBarBackButtonHidden(true)) {
                        Text("Start")
                            .font(.system(size: 30))
                            .padding()
                            .background(Color.purple)
                            .foregroundColor(.white)
                            .fontWeight(.bold)
                            .cornerRadius(10)
                    }
            }
            NavigationLink(destination: MapSelectionView(viewModel: viewModel)) {
                Text("Select Map")
                    .font(.system(size: 30))
                    .padding()
                    .background(Color.purple)
                    .foregroundColor(.white)
                    .fontWeight(.bold)
                    .cornerRadius(10)
            }
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
    }

    private var readyButton: some View {
        Button(action: {
            isReady = true
            viewModel.start()
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
}
