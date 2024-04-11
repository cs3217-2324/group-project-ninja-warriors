//
//  SinglePlayerLobbyView.swift
//  NinjaWarriors
//
//  Created by Muhammad Reyaaz on 9/4/24.
//

import Foundation
import SwiftUI

struct SinglePlayerLobbyView: View {
    @State private var isReady: Bool = false
    @ObservedObject var viewModel: SinglePlayerViewModel

    init() {
        self.viewModel = SinglePlayerViewModel()
    }

    var body: some View {
        VStack {
            NavigationView {
                VStack(spacing: 10) {
                    NavigationLink(destination: SingleCharacterSelectionView(viewModel: viewModel)) {
                        Text("SELECT CHARACTER")
                            .font(.system(size: 30))
                            .padding()
                            .background(Color.purple)
                            .foregroundColor(.white)
                            .fontWeight(.bold)
                            .cornerRadius(10)
                    }
                    NavigationLink(
                        destination: HostSinglePlayerView(matchId: viewModel.matchId,
                                                          currPlayerId: viewModel.hostId)
                        .navigationBarBackButtonHidden(true),
                        isActive: $isReady) { EmptyView() }
                    Button(action: {
                        viewModel.start()
                        isReady = true
                    }) {
                        Text("START GAME")
                            .font(.system(size: 30))
                            .padding()
                            .background(Color.purple)
                            .foregroundColor(.white)
                            .fontWeight(.bold)
                            .cornerRadius(10)
                    }
                }
                .background(
                    Image("lobby-bg")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .edgesIgnoringSafeArea(.all)
                        .frame(width: Constants.screenWidth, height: Constants.screenHeight)
                )
            }
            .navigationViewStyle(.stack)
            .navigationBarBackButtonHidden(true)
        }
    }
}
