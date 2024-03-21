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
    @ObservedObject var viewModel = LobbyViewModel()

    var body: some View {
        NavigationView {
            VStack {
                if let user = signInViewModel.user {
                    Text("UID: \(user.uid)")
                        .padding()
                    Text("Email: \(user.email ?? "N/A")")
                        .padding()
                }
                if let playerCount = viewModel.getPlayerCount() {
                    Text("Player Count: \(playerCount)")
                        .padding()
                    if playerCount == Constants.playerCount {
                        Text("")
                            .hidden()
                            .onAppear {
                                Task {
                                    try await viewModel.start()
                                }
                            }
                        if let matchId = viewModel.matchId,
                           let players = viewModel.playerIds {
                            NavigationLink(destination: CanvasView(matchId: matchId,
                                                                   /*playerIds: players,*/
                                                                   entities: viewModel.entities,
                                                                   currPlayerId: signInViewModel.getUserId() ?? "none")) {
                                Text("Start Game")
                                    .font(.system(size: 30))
                                    .padding()
                                    .background(Color.blue)
                                    .foregroundColor(.black)
                                    .cornerRadius(10)
                            }
                            .padding()
                        }
                    }
                }
                Button(action: {
                    if let userId = signInViewModel.getUserId() {
                        if isReady {
                            viewModel.unready(userId: userId)
                            isReady = false
                        } else {
                            viewModel.ready(userId: userId)
                            isReady = true
                        }
                    }
                }) {
                    Text(isReady ? "Unready" : "Ready")
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.blue)
                        .cornerRadius(10)
                }
                .padding()
                .opacity(isReady ? 0.7 : 1.0)
            }
        }.navigationViewStyle(.stack)
    }
}
