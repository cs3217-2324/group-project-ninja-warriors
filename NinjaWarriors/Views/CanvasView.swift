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
    @State private var matchId: String
    @State private var joystickPosition: CGPoint = .zero
    // Add state to hold the joystick's output
    @State private var joystickOutput: CGPoint = .zero

    init(matchId: String, currPlayerId: String) {
        self.matchId = matchId
        self.viewModel = CanvasViewModel(matchId: matchId, currPlayerId: currPlayerId)
    }

    var body: some View {
        VStack {
            GeometryReader { geometry in
                ZStack {
                    ForEach(viewModel.entities.compactMap { $0 }, id: \.id) { entity in
                            VStack {
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
                                Text("\(entity.id)")
                            }
                    }
                }

                HStack {
                    JoystickView(location: CGPoint(x: 120, y: geometry.size.height - 120),
                                 innerCircleLocation: joystickOutput)
                        .onChange(of: joystickOutput) { newPosition in
                            viewModel.changePosition(entityId: viewModel.currPlayerId, newPosition: newPosition)
                        }
                        .offset(x: 120, y: geometry.size.height - 120)

                    Spacer()

                    Button(action: {
                    }) {
                        Text("Skill 1")
                    }.offset(y: geometry.size.height - 500)
                    .padding()

                    Spacer(minLength: 20)

                    Button(action: {
                    }) {
                        Text("Skill 2")
                    }.offset(y: geometry.size.height - 500)
                    .padding()

                    Spacer(minLength: 20)

                    Button(action: {
                    }) {
                        Text("Skill 3")
                    }.offset(y: geometry.size.height - 500)
                    .padding()

                    Spacer(minLength: 20)

                    Button(action: {

                    }) {
                        Text("Skill 4")
                    }.offset(y: geometry.size.height - 500)
                    .padding()
                }
            }
        }
        .onAppear {
            viewModel.addListeners()
        }
    }
}

struct CanvasView_Previews: PreviewProvider {
    static var previews: some View {
        CanvasView(matchId: "SampleMatchID", currPlayerId: "SamplePlayerID")
    }
}
