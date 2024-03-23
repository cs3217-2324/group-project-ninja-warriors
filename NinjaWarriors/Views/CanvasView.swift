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
    @State private var isShowingEntityOverlay = false

    @State private var matchId: String
    @State private var joystickPosition: CGPoint = .zero
    // Add state to hold the joystick's output
    //@State private var joystickOutput: CGPoint = .zero

    init(matchId: String, currPlayerId: String) {
        self.matchId = matchId
        self.viewModel = CanvasViewModel(matchId: matchId, currPlayerId: currPlayerId)
    }

    var body: some View {
        ZStack {
            EntityOverlayView(entities: viewModel.entities,
                              componentManager: viewModel.gameWorld.entityComponentManager)
                .frame(maxWidth: 1000, alignment: .leading)
                .transition(.move(edge: .trailing))
                .animation(.default, value: isShowingEntityOverlay)
                .zIndex(1) // Ensure the overlay is above all other content
                .opacity(isShowingEntityOverlay ? 1 : 0)

            Button(action: {
                isShowingEntityOverlay.toggle()
            }, label: {
                Image(systemName: "eye")
                    .accessibilityLabel("Toggle Entity Overlay")
            })
            .padding()
            .background(Color.blue.opacity(0.7))
            .foregroundColor(.white)
            .clipShape(Circle())
            .padding([.top, .trailing])
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
                                                viewModel.changePosition(entityId: entityId,
                                                                         newPosition: joystickPosition)
                                            }
                                    )
                                Text("\(entity.id)")
                            }
                        }
                    }
                    HStack {
                        if viewModel.gameControl is JoystickControl {
                            JoystickView(setInputVector: { vector in
                                viewModel.gameControl.setInputVector(vector)
                            }, location: CGPoint(x: 120, y: geometry.size.height - 120))
                            .offset(x: 100, y: 100)
                        }
                        Spacer()
                        ForEach(viewModel.getSkillIds(for: viewModel.currPlayerId), id: \.self) { skillId in
                            Button(action: {
                                viewModel.activateSkill(forEntityWithId: viewModel.currPlayerId, skillId: skillId)
                            }) {
                                Text("\(skillId)")
                            }
                            .padding()
                        }

                    }
                }
            }
            .onAppear {
                viewModel.addListeners()
            }
        }
    }
}

struct CanvasView_Previews: PreviewProvider {
    static var previews: some View {
        CanvasView(matchId: "SampleMatchID", currPlayerId: "SamplePlayerID")
    }
}
