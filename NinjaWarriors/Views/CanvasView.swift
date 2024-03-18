//
//  CanvasView.swift
//  NinjaWarriors
//
//  Created by Muhammad Reyaaz on 15/3/24.
//

import Foundation
import SwiftUI

struct CanvasView: View {
    @ObservedObject var viewModel: CanvasViewModel
    @State private var joystickPosition: CGPoint = .zero
    @State private var matchId: String

    // Add state to hold the joystick's output
    @State private var joystickOutput: CGPoint = .zero

    init(matchId: String, playerIds: [String], currPlayerId: String) {
        self.matchId = matchId
        self.viewModel = CanvasViewModel(matchId: matchId, playerIds: playerIds, currPlayerId: currPlayerId)
    }

    var body: some View {
        VStack {
            Text("currPlayerId: \(viewModel.currPlayerId)")
            Text("Player Count: \(viewModel.players.count)")
                .padding()
            Text("Both the database as well as the view will update in real time, simulating multiplayer mode")
            GeometryReader { geometry in
                ZStack {
                    // Position the JoystickView
                    JoystickView(location: CGPoint(x: 400, y: 400),
                                innerCircleLocation: joystickOutput)
                        .onChange(of: joystickOutput) { newPosition in
                            viewModel.changePosition(playerId: viewModel.currPlayerId, newPosition: newPosition)
                        }
                    // Player Circles
                    ForEach(viewModel.players, id: \.id) { player in
                        Text("\(player.id)")
                        Circle()
                            .fill(Color.blue)
                            .frame(width: 50, height: 50)
                            .position(player.getPosition())
                    }
                }
            }
        }
        .onAppear {
            viewModel.addListenerForPlayers()
        }
    }
}
