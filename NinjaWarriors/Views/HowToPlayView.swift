//
//  HowToPlayView.swift
//  NinjaWarriors
//
//  Created by Muhammad Reyaaz on 15/4/24.
//

import Foundation

import SwiftUI

struct HowToPlayView: View {
    @State private var joystickOffset: CGFloat = -50
    @State private var ringRotation: Double = 0
    @State private var isBlinking = false

    let joystickSize: CGFloat = 50
    @State var ringSize: CGFloat = 200
    @State var ringStrokeWidth: CGFloat = 3
    let imageSize: CGFloat = 100

    var body: some View {
        VStack {
            HStack {
                // Top Left: Joystick
                VStack {

                    Circle()
                        .stroke(Color.blue.opacity(0.3), lineWidth: 5)
                        .frame(width: 150, height: 150)
                        .overlay(
                            Circle()
                                .fill(Color.blue)
                                .frame(width: joystickSize, height: joystickSize)
                                .offset(x: joystickOffset, y: 0)
                                .onAppear {
                                    withAnimation(Animation.linear(duration: 2).repeatForever(autoreverses: true)) {
                                        joystickOffset = 50
                                    }
                                }
                        )
                }
                .frame(width: 250, height: 250) // Move the frame modifier here
                .padding()
                .background(Color.gray)
                .cornerRadius(10)

                // Top Right: Closing Ring Animation
                VStack {
                    ZStack {
                        Circle()
                            .fill(Color.blue.opacity(0.3))
                            .frame(width: 250, height: 250)

                        Circle()
                            .trim(from: 0, to: 1)
                            .fill(Color.gray)
                            .frame(width: ringSize, height: ringSize)
                            .rotationEffect(.degrees(ringRotation))
                            .onAppear {
                                withAnimation(Animation.linear(duration: 10).repeatForever(autoreverses: false)) {
                                    ringSize = 20
                                }
                            }
                    }
                }
                .frame(width: 250, height: 250)
                .padding()
                .background(Color.gray)
                .cornerRadius(10)
            }

            HStack {
                VStack {
                    HStack {
                        Image("gem")
                            .resizable()
                            .frame(width: 100, height: 100)
                            .brightness(isBlinking ? 0.4 : 0)
                            .opacity(isBlinking ? 1.0 : 1.0)
                            .onAppear {
                                withAnimation(Animation.linear(duration: 2).repeatForever(autoreverses: true)) {
                                    isBlinking.toggle()
                                }
                            }

                        Image("gem-2")
                            .resizable()
                            .frame(width: 100, height: 100)
                            .brightness(isBlinking ? 0.4 : 0)
                            .opacity(isBlinking ? 1.0 : 1.0)
                            .onAppear {
                                withAnimation(Animation.linear(duration: 2).repeatForever(autoreverses: true)) {
                                    isBlinking.toggle()
                                }
                            }
                    }
                    .padding()

                    HStack {
                        Image("gem-3")
                            .resizable()
                            .frame(width: 100, height: 100)
                            .brightness(isBlinking ? 0.4 : 0)
                            .opacity(isBlinking ? 1.0 : 1.0)
                            .onAppear {
                                withAnimation(Animation.linear(duration: 2).repeatForever(autoreverses: true)) {
                                    isBlinking.toggle()
                                }
                            }

                        Image("gem-4")
                            .resizable()
                            .frame(width: 75, height: 75)
                            .brightness(isBlinking ? 0.4 : 0)
                            .opacity(isBlinking ? 1.0 : 1.0)
                            .onAppear {
                                withAnimation(Animation.linear(duration: 2).repeatForever(autoreverses: true)) {
                                    isBlinking.toggle()
                                }
                            }
                    }
                    .padding()
                }.offset(x: -25)

                VStack {
                    VStack {
                        HStack {
                            Image("skill-refresh")
                                .resizable()
                                .frame(width: 100, height: 100)
                                .brightness(isBlinking ? 0.4 : 0)
                                .opacity(isBlinking ? 1.0 : 1.0)
                                .onAppear {
                                    withAnimation(Animation.linear(duration: 2).repeatForever(autoreverses: true)) {
                                        isBlinking.toggle()
                                    }
                                }

                            Image("skill-hadouken")
                                .resizable()
                                .frame(width: 100, height: 100)
                                .brightness(isBlinking ? 0.4 : 0)
                                .opacity(isBlinking ? 1.0 : 1.0)
                                .onAppear {
                                    withAnimation(Animation.linear(duration: 2).repeatForever(autoreverses: true)) {
                                        isBlinking.toggle()
                                    }
                                }
                        }
                        .padding()

                        HStack {
                            Image("skill-dodge")
                                .resizable()
                                .frame(width: 100, height: 100)
                                .brightness(isBlinking ? 0.4 : 0)
                                .opacity(isBlinking ? 1.0 : 1.0)
                                .onAppear {
                                    withAnimation(Animation.linear(duration: 2).repeatForever(autoreverses: true)) {
                                        isBlinking.toggle()
                                    }
                                }

                            Image("skill-dash")
                                .resizable()
                                .frame(width: 75, height: 75)
                                .brightness(isBlinking ? 0.4 : 0)
                                .opacity(isBlinking ? 1.0 : 1.0)
                                .onAppear {
                                    withAnimation(Animation.linear(duration: 2).repeatForever(autoreverses: true)) {
                                        isBlinking.toggle()
                                    }
                                }
                        }
                        .padding()
                    }.offset(x: 25)

                }
            }
            .padding()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(
            Image("bg")
            .resizable()
            .edgesIgnoringSafeArea(.all)
            .scaledToFill()
        )
    }
}

struct HowToPlayView_Previews: PreviewProvider {
    static var previews: some View {
        HowToPlayView()
    }
}
