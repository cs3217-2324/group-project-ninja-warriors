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
                NavigationLink(
                    destination: HostView(matchId: viewModel.matchId, currPlayerId: "a").navigationBarBackButtonHidden(true)
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
    }
}
