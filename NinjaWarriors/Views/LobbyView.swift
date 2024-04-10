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
            VStack() {
                Spacer()
                userLoginInfo
                if let playerCount = viewModel.getPlayerCount() {

                    customText("Player Count: \(playerCount) / \(Constants.playerCount)")

                    if playerCount == Constants.playerCount {

                        startRender

                        if let matchId = viewModel.matchId, viewModel.playerIds != nil {

                            customText("Match id: \(matchId)")

                            if viewModel.getUserId() == viewModel.hostId {
                                NavigationLink(
                                    destination: HostView(matchId: matchId, currPlayerId: viewModel.getUserId()).navigationBarBackButtonHidden(true)
                                ) {
                                    startGameText
                                }
                            } else {
                                NavigationLink(
                                    destination: ClientView(matchId: matchId, currPlayerId: viewModel.getUserId()).navigationBarBackButtonHidden(true)
                                ) {
                                    startGameText
                                }
                            }
                        }
                    }
                }
                readyButton
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
                .padding()
                .foregroundColor(.white)
                .background(Color.blue)
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
        Text("START GAME")
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

