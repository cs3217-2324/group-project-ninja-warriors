//
//  CanvasView.swift
//  NinjaWarriors
//
//  Created by Muhammad Reyaaz on 15/3/24.
//

import Foundation
import SwiftUI

struct CanvasView: View {
    @ObservedObject var viewModel = CanvasViewModel()
    @State private var joystickPosition: CGPoint = .zero
    @State private var playerId: String = ""

    var body: some View {
        VStack {
            TextField("Enter Player ID", text: $playerId)
                .padding()
                .textFieldStyle(RoundedBorderTextFieldStyle())

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
                                        let playerId = playerId.trimmingCharacters(in: .whitespacesAndNewlines)
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
