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

    init(matchId: String, entities: [Entity], currPlayerId: String) {
        self.matchId = matchId
        self.viewModel = CanvasViewModel(matchId: matchId, currPlayerId: currPlayerId)
    }

    var body: some View {
        VStack {
            Text("currPlayerId: \(viewModel.currPlayerId) \(viewModel.entities.count)")
                .padding()
            Text("Both the database as well as the view will update in real time, simulating multiplayer mode")
            GeometryReader { geometry in
                ZStack {
                    // Position the JoystickView
                    JoystickView(location: CGPoint(x: 400, y: 400),
                                innerCircleLocation: joystickOutput)
                        .onChange(of: joystickOutput) { newPosition in
                            viewModel.changePosition(entityId: viewModel.currPlayerId, newPosition: newPosition)
                        }
                    // Player Circles
                    ForEach(viewModel.entities, id: \.id) { entity in
                        Text("\(entity.id)")
                        if let entity = entity {
                            Circle()
                                .fill(Color.blue)
                                .frame(width: 50, height: 50)
                                .position(entity.shape.getCenter())
                                .gesture(
                                    DragGesture()
                                        .onChanged { gesture in
                                            let newX = max(0, min(gesture.location.x, geometry.size.width))
                                            let newY = max(0, min(gesture.location.y, geometry.size.height))
                                            joystickPosition = CGPoint(x: newX, y: newY)
                                            let entityId = entity.id
                                            viewModel.changePosition(entityId: entityId, newPosition: joystickPosition)
                                        }
                                )

                        }
                    }
                }
            }
        }
        .onAppear {
            viewModel.addListenerForPlayers()
        }
    }
}
