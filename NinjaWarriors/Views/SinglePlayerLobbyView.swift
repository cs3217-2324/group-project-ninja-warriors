//
//  SinglePlayerLobbyView.swift
//  NinjaWarriors
//
//  Created by Muhammad Reyaaz on 9/4/24.
//

import Foundation
import SwiftUI

struct SinglePlayerLobbyView: View {
    @EnvironmentObject var signInViewModel: SignInViewModel
    @State private var isReady: Bool = false
    @ObservedObject var viewModel: SinglePlayerViewModel

    init() {
        self.viewModel = SinglePlayerViewModel()
    }

    init(viewModel: SinglePlayerViewModel) {
        self.viewModel = viewModel
    }

    var body: some View {
        NavigationView {
            VStack {
                NavigationLink(
                    destination: HostSinglePlayerView(matchId: viewModel.matchId,
                                          currPlayerId: viewModel.hostId)
                    .navigationBarBackButtonHidden(true)
                ) {
                    Text("START GAME")
                        .font(.system(size: 30))
                        .padding()
                        .background(Color.purple)
                        .foregroundColor(.white)
                        .fontWeight(.bold)
                        .cornerRadius(10)
                }
            }
        }.navigationViewStyle(.stack)
        .navigationBarBackButtonHidden(true)
    }
}
