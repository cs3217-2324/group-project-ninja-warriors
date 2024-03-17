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
        VStack {
            if let user = signInViewModel.user {
                Text("UID: \(user.uid)")
                    .padding()
                Text("Email: \(user.email ?? "N/A")")
                    .padding()
            }
            if let playerCount = viewModel.playerCount {
                Text("Player Count: \(playerCount)")
                    .padding()
            }
            if let matchId = viewModel.matchId {
                Text("Match Id: \(matchId)")
                    .padding()
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
    }
}
