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
            Text("How To Play")
                .padding(.bottom, 50)
                .font(.custom("KARASHA", size: 70))
                .foregroundColor(.white)
            HStack {
                // Top Left: Joystick
                VStack {
                    Circle()
                        .stroke(Color.white.opacity(0.3), lineWidth: 5)
                        .frame(width: 200, height: 200)
                        .overlay(
                            Circle()
                                .fill(Color.white)
                                .frame(width: joystickSize, height: joystickSize)
                                .offset(x: joystickOffset, y: 0)

                                .onAppear {
                                    DispatchQueue.main.asyncAfter(deadline: .now() + DispatchTimeInterval.milliseconds(200)) {
                                        withAnimation(Animation.linear(duration: 2).repeatForever(autoreverses: true)) {
                                            joystickOffset = 50
                                        }
                                    }
                                }
                        )
                    Spacer()
                    Text("Joystick controls the player")
                    .padding(.bottom, -10)
                    .font(.system(size: 18, weight: .bold))
                    .foregroundColor(.white)
                }
                .frame(width: 250, height: 250)
                .padding()
                .background(Color.gray.opacity(0.8))
                .cornerRadius(10)

                // Top Right: Closing Ring Animation
                VStack {
                    ZStack {
                        Circle()
                            .fill(Color.blue.opacity(0.3))
                            .frame(width: 220, height: 220)

                        Circle()
                            .trim(from: 0, to: 1)
                            .fill(Color.gray)
                            .frame(width: ringSize, height: ringSize)
                            .rotationEffect(.degrees(ringRotation))
                            .onAppear {
                                DispatchQueue.main.asyncAfter(deadline: .now() + DispatchTimeInterval.milliseconds(200)) {
                                    withAnimation(Animation.linear(duration: 10).repeatForever(autoreverses: false)) {
                                        ringSize = 20
                                    }
                                }
                            }
                    }
                    Text("Avoid the closing zone!")
                    .padding(.top, 15)
                    .font(.system(size: 18, weight: .bold))
                    .foregroundColor(.white)
                }
                .frame(width: 250, height: 250)
                .padding()
                .background(Color.gray)
                .cornerRadius(10)
            }

            HStack {
                VStack {
                    // Bottom Left: Blinking Gems
                    HStack {
                        Image("gem")
                            .resizable()
                            .frame(width: 100, height: 100)
                            .brightness(isBlinking ? 0.4 : 0)
                            .opacity(isBlinking ? 1.0 : 1.0)
                            .onAppear {
                                DispatchQueue.main.asyncAfter(deadline: .now() + DispatchTimeInterval.milliseconds(200)) {
                                    withAnimation(Animation.linear(duration: 2).repeatForever(autoreverses: true)) {
                                        isBlinking.toggle()
                                    }
                                }
                            }

                        Image("gem-2")
                            .resizable()
                            .frame(width: 100, height: 100)
                            .brightness(isBlinking ? 0.4 : 0)
                            .opacity(isBlinking ? 1.0 : 1.0)
                    }
                    .padding()

                    HStack {
                        Image("gem-3")
                            .resizable()
                            .frame(width: 100, height: 100)
                            .brightness(isBlinking ? 0.4 : 0)
                            .opacity(isBlinking ? 1.0 : 1.0)

                        Image("gem-4")
                            .resizable()
                            .frame(width: 75, height: 75)
                            .brightness(isBlinking ? 0.4 : 0)
                            .opacity(isBlinking ? 1.0 : 1.0)
                    }
                    .padding()
                    Text("Collect gems to earn points")
                        .padding(.top, -25)
                        .font(.system(size: 18, weight: .bold))
                        .foregroundColor(.white)
                }
                    .frame(width: 250, height: 250)
                    .padding()
                    .background(Color.gray.opacity(0.8))
                    .cornerRadius(10)

                VStack {
                    VStack {
                        // Bottom Right: Skills
                        HStack {
                            Image("skill-refresh")
                                .resizable()
                                .frame(width: 100, height: 100)

                            Image("skill-hadouken")
                                .resizable()
                                .frame(width: 100, height: 100)
                        }
                        .padding()

                        HStack {
                            Image("skill-dodge")
                                .resizable()
                                .frame(width: 100, height: 100)

                            Image("skill-dash")
                                .resizable()
                                .frame(width: 100, height: 100)
                        }
                        .padding()
                        Text("Tap to use your skills!")
                            .padding(.top, -20)
                            .font(.system(size: 18, weight: .bold))
                            .foregroundColor(.white)
                    }
                }
                .frame(width: 250, height: 250)
                .padding()
                .background(Color.gray.opacity(0.8))
                .cornerRadius(10)
            }
            .padding()
        }
        .offset(y: -50)
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
