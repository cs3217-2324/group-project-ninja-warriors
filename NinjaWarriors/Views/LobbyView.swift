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
                    Image("player-copy")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 50, height: 50)
                        .position(x: Constants.screenWidth / 2, y: Constants.screenHeight / 2)
                if let user = signInViewModel.user {
                    Text("UID: \(user.uid)")
                        .padding()
                    Text("Email: \(user.email ?? "N/A")")
                        .padding()
                }
                if let playerCount = viewModel.getPlayerCount() {
                    Text("Player Count: \(playerCount) / \(Constants.playerCount)")
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
                           viewModel.playerIds != nil {
                            Text("\(matchId)")
                            NavigationLink(destination:
                                            CanvasView(matchId: matchId,
                                                       currPlayerId: signInViewModel.getUserId() ??
                                                       "none").navigationBarBackButtonHidden(true)) {
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
                }, label: {
                    Text(isReady ? "Unready" : "Ready")
                        .foregroundColor(.white)
                        .padding()
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

/*
struct LobbyView: View {
    @EnvironmentObject var signInViewModel: SignInViewModel
    @State private var isReady: Bool = false
    @State var matchId = "10"
    @ObservedObject var viewModel = LobbyViewModel()

    var body: some View {
        NavigationView {
            VStack {
                Image("player-copy")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 50, height: 50)
                    .position(x: Constants.screenWidth / 2, y: Constants.screenHeight / 2)
                Text("UID: Testing user id")
                    .padding()
                Text("Email: Testing email")
                    .padding()
                Text("Player Count: 10")
                    .padding()


                Text("\(matchId)")
                NavigationLink(destination:
                                CanvasView(matchId: matchId,
                                           currPlayerId: "test").navigationBarBackButtonHidden(true)) {
                    Text("Start Game")
                        .font(.system(size: 30))
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.black)
                        .cornerRadius(10)
                }
                                           .padding()
            }
            Button(action: {
                if isReady {
                    isReady = false
                } else {
                    isReady = true
                }
            }, label: {
                Text(isReady ? "Unready" : "Ready")
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.blue)
                    .cornerRadius(10)
            })
            .padding()
            .opacity(isReady ? 0.7 : 1.0)
        }.navigationViewStyle(.stack)
        .background(
            Image("lobby-bg")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .edgesIgnoringSafeArea(.all)
                .frame(width: Constants.screenWidth, height: Constants.screenHeight)
        )
    }
}

struct LobbyView_Previews: PreviewProvider {
    static var previews: some View {
        return LobbyView()
    }
}
*/
