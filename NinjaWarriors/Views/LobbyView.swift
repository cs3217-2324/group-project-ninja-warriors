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

    init(viewModel: LobbyViewModel) {
        self.viewModel = viewModel
    }

    var body: some View {
        NavigationView {
            VStack {
                    Image("player-icon")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 100, height: 100)
                        .position(x: Constants.screenWidth / 2, y: Constants.screenHeight / 2)
                if let user = signInViewModel.user {
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

                            //if signInViewModel.getUserId() != "kn2Ap0BtgChusWyyHZtpV42RxmZ2" {
                            if signInViewModel.getUserId() == viewModel.hostId {
                                NavigationLink(
                                    destination: HostView(matchId: matchId, currPlayerId: signInViewModel.getUserId() ?? "none").navigationBarBackButtonHidden(true)
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
                                    destination: ClientView(matchId: matchId, currPlayerId: signInViewModel.getUserId() ?? "none").navigationBarBackButtonHidden(true)
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
                            //.padding()
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
                }, label: {
                    Text(isReady ? "Unready" : "Ready")
                        .padding()
                        .foregroundColor(.white)
                        .background(Color.blue)
                        .cornerRadius(10)
                })
                .padding()
                .opacity(isReady ? 0.7 : 1.0)
            }
            .background(
                Image("lobby-bg")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .edgesIgnoringSafeArea(.all)
                    .frame(width: Constants.screenWidth, height: Constants.screenHeight)
            )
        }.navigationViewStyle(.stack)
    }
}
