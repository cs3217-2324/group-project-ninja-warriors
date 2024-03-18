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

    init(matchId: String, playerIds: [String]) {
        self.matchId = matchId
        self.viewModel = CanvasViewModel(matchId: matchId, playerIds: playerIds)
    }

    var body: some View {
        VStack {
            Text("Player Count: \(viewModel.players.count)")
                .padding()
            Text("Both the database as well as the view will update in real time, simulating multiplayer mode")
            GeometryReader { geometry in
                ZStack {
                    ForEach(viewModel.players, id: \.id) { player in
                        Circle()
                            .fill(Color.blue)
                            .frame(width: 50, height: 50)
                            .position(player.getPosition())
                            .gesture(
                                DragGesture()
                                    .onChanged { gesture in
                                        let newX = max(0, min(gesture.location.x, geometry.size.width))
                                        let newY = max(0, min(gesture.location.y, geometry.size.height))
                                        joystickPosition = CGPoint(x: newX, y: newY)
                                        let playerId = player.id
                                        viewModel.changePosition(playerId: playerId, newPosition: joystickPosition)
                                    }
                            )
                    }
                }
            }
        }
        .onAppear {
            viewModel.addListenerForPlayers()
        }
    }
}
