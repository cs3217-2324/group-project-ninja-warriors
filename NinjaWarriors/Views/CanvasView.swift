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
    @State private var playerPosition = CGPoint(x: 300.0, y: 300.0)

    init(matchId: String, currPlayerId: String) {
        self.matchId = matchId
        self.viewModel = CanvasViewModel(matchId: matchId, currPlayerId: currPlayerId)
    }

    var body: some View {
        ZStack {
            Image("grass-stone")
                .resizable()
                .edgesIgnoringSafeArea(.all)
            
            ZStack {
                GeometryReader { geometry in
                    ZStack {
                        ForEach(viewModel.entities.compactMap { $0 }, id: \.id) { entity in
                            VStack {
                                Image("player-copy")
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: 50, height: 50)
                                    .position(entity.shape.getCenter())
                                    .position(x: playerPosition.x,
                                              y: playerPosition.y)
                                Text("\(entity.id)")
                            }
                        }
                    }
                    if viewModel.gameControl is JoystickControl {
                        JoystickView(
                            playerPosition: $playerPosition,
                            setInputVector: { vector in
                                viewModel.changePosition(newPosition: playerPosition)
                            //viewModel.gameControl.setInputVector(vector)
                            }, location: CGPoint(x: 200, y: geometry.size.height - 300))
                        .frame(width: 200, height: 200)
                    }
                    VStack {
                        Spacer()
                        HStack {
                            ZStack {
                                Button(action: {
                                    isShowingEntityOverlay.toggle()
                                }, label: {
                                    Image(systemName: "eye")
                                    .accessibilityLabel("Toggle Entity Overlay")})
                                .padding()
                                .background(Color.blue.opacity(0.7))
                                .foregroundColor(.white)
                                .clipShape(Circle())
                            }
                            HStack {
                                ForEach(viewModel.getSkills(for: viewModel.currPlayerId), id: \.key) { key, value in
                                    Button(action: {
                                        viewModel.activateSkill(forEntityWithId: viewModel.currPlayerId, skillId: key)
                                    }, label: {
                                        Text("\(key) \(String(format: "%.1f", value.cooldownRemaining))")
                                    })
                                    .padding()
                                    .background(Color.white.opacity(0.7))
                                }
                            }
                        }.frame(maxWidth: .infinity, maxHeight: 100)
                            .background(Color.red.opacity(0.5))
                    }
                }
                EntityOverlayView(entities: viewModel.entities,
                                      componentManager: viewModel.gameWorld.entityComponentManager)
                    .zIndex(-1)
                    .opacity(isShowingEntityOverlay ? 1 : 0)
                
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
