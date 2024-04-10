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
            VStack {
                if !viewModel.isGuest, let user = signInViewModel.user {
                        Text("UID: \(user.uid)")
                            .padding()
                            .fontWeight(.medium)
                            .foregroundColor(.white)
                        Text("Email: \(user.email ?? "N/A")")
                            .padding()
                            .fontWeight(.medium)
                            .foregroundColor(.white)
                    }
                if let playerCount = viewModel.getPlayerCount() {
                    Text("Player Count: \(playerCount) / \(Constants.playerCount)")
                        .padding()
                        .fontWeight(.medium)
                        .foregroundColor(.white)
                    if playerCount == Constants.playerCount {
                        Text("")
                            .hidden()
                            .onAppear {
                                Task {
                                    await viewModel.start()
                                }
                            }
                        if let matchId = viewModel.matchId,
                           viewModel.playerIds != nil {
                            Text("\(matchId)")
                                .fontWeight(.medium)
                                .foregroundColor(.white)

                            if viewModel.getUserId() == viewModel.hostId {
                                NavigationLink(
                                    destination: HostView(matchId: matchId, currPlayerId: viewModel.getUserId()).navigationBarBackButtonHidden(true)
                                ) {
                                    Text("START GAME")
                                        .font(.system(size: 30))
                                        .padding()
                                        .background(Color.purple)
                                        .foregroundColor(.white)
                                        .fontWeight(.bold)
                                        .cornerRadius(10)
                                }
                            } else {
                                NavigationLink(
                                    destination: ClientView(matchId: matchId, currPlayerId: viewModel.getUserId()).navigationBarBackButtonHidden(true)
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
                        }
                    }
                }
                Button(action: {
                    viewModel.ready(userId: (viewModel.isGuest ? viewModel.guestId : signInViewModel.getUserId()) ?? "none")
                }) {
                    Text("Ready")
                        .padding()
                        .foregroundColor(.white)
                        .background(Color.blue)
                        .cornerRadius(10)
                }
                .padding()
                .opacity({
                    if isReady && viewModel.getPlayerCount() == Constants.playerCount {
                        return 0
                    } else if isReady {
                        return 0.2
                    } else {
                        return 1.0
                    }
                }())
                .disabled(isReady)
                .buttonStyle(ConditionalButtonStyle(isReady: isReady))
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
}


struct ConditionalButtonStyle: ButtonStyle {
    var isReady: Bool

    func makeBody(configuration: Configuration) -> some View {
        if isReady {
            configuration.label
                .buttonStyle(PlainButtonStyle())
        } else {
            configuration.label
        }
    }
}
