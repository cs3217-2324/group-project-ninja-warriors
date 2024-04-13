//
//  InstructionView.swift
//  Peggle
//
//  Created by Muhammad Reyaaz on 29/2/24.
//

import SwiftUI

struct InstructionView: View {
    @State private var readyToNavigate = false
    @State private var isButtonClicked = false
    @State private var isSecondaryButtonClicked = false
    @State private var degreesRotating = 0.0
    @State private var xOffset: CGFloat = -70.0

    private let shooter = "shooterItem-rotate"
    private let capture = "captureObjectItem"
    private let buttonText = "Show Levels"
    private let shooterText = "Rotate the scarab shooter, then tap on the background to shoot."
    private let captureText = "When a ball falls into the scarab, you receive a free ball, but the limit is 10."

    private let maxOffset: CGFloat = 70.0
    private let maxRotationAngle: CGFloat = 180.0
    private let infoWidth: CGFloat = Constants.screenWidth / 3
    private let infoHeight: CGFloat = Constants.screenWidth / 3
    private let infoSpacing: CGFloat = Constants.screenWidth / 10
    private let desertLightBrown = Constants.desertLightBrown
    private let desertDarkBrown = Constants.desertDarkBrown
    private let shadowColor = Color.black.opacity(0.6)
    private let shadowRadius: CGFloat = 5
    private let shadowY: CGFloat = 3
    private let fontSize: CGFloat = 20

    var body: some View {
        NavigationStack {
            ZStack {
                screenDisplay
                VStack {
                    IntroDisplayView()
                    Spacer()
                    gridDisplay
                    Spacer()
                    DecalView()
                    Spacer()
                    customButton
                }
            }
        }.transition(.slide)
    }
}

extension InstructionView {
    private var screenDisplay: some View {
        Rectangle()
            .fill(LinearGradient(
                gradient: Gradient(colors: [
                    desertLightBrown,
                    desertLightBrown.opacity(0.9),
                    desertLightBrown.opacity(0.6),
                    desertLightBrown.opacity(0.9),
                    desertLightBrown.opacity(0.7)
                ]),
                startPoint: .top,
                endPoint: .bottom
            ))
            .edgesIgnoringSafeArea(.all)
            .frame(width: Constants.screenWidth)
            .navigationDestination(isPresented: $readyToNavigate) {
                CanvasView().navigationBarBackButtonHidden(true)
            }
    }
}

extension InstructionView {
    private var customButton: some View {
        Button(action: {
            AudioManager.shared.playButtonClickAudio()
            readyToNavigate = true
        }) {
            Text(buttonText)
                .font(.system(size: fontSize, weight: .bold))
                .foregroundColor(.black)
                .padding(.horizontal, 100)
                .padding(.vertical, 20)
                .background(desertDarkBrown)
                .cornerRadius(8)
        }
    }
}

extension InstructionView {
    private var shooterInfoDisplay: some View {
        ZStack {
            InfoDisplayBoxView()
            shooterDisplay
        }
    }
}

extension InstructionView {
    private var captureInfoDisplay: some View {
        ZStack {
            InfoDisplayBoxView()
            captureDisplay
        }
    }
}

extension InstructionView {
    private var powerInfoDisplay: some View {
        ZStack {
            InfoDisplayBoxView()
            ObjectDisplayView()
        }
    }
}

extension InstructionView {
    private var themeInfoDisplay: some View {
        ZStack {
            InfoDisplayBoxView()
            ThemeDisplayView()
        }
    }
}

extension InstructionView {
    private var shooterDisplay: some View {
        VStack {
            Image(shooter)
                .resizable()
                .rotationEffect(.degrees(degreesRotating))
                .frame(width: infoWidth / 2, height: infoWidth / 2)
                .onAppear {
                    withAnimation(.linear(duration: 1)
                        .speed(0.5).repeatForever(autoreverses: true)) {
                            degreesRotating = maxRotationAngle
                    }
                }
            Text(shooterText)
                .font(.system(size: 20, weight: .bold))
                .lineLimit(nil)
                .frame(width: infoWidth)
        }
    }
}

extension InstructionView {
    private var captureDisplay: some View {
        VStack {
            Image(capture)
                .resizable()
                .frame(width: infoWidth / 2, height: infoWidth / 3)
                .offset(x: xOffset)
                .onAppear {
                    withAnimation(Animation.linear(duration: 1)
                        .speed(0.8)
                        .repeatForever(autoreverses: true)) {
                            xOffset = maxOffset
                    }
                }
            Text(captureText)
                .font(.system(size: 20, weight: .bold))
                .lineLimit(nil)
                .frame(width: infoWidth)
        }

    }
}

extension InstructionView {
    private var gridDisplay: some View {
        HStack {
            Spacer()
            VStack(spacing: infoSpacing) {
                HStack(spacing: infoSpacing) {
                    shooterInfoDisplay
                    captureInfoDisplay
                }
                IconsView()
                HStack(spacing: infoSpacing) {
                    powerInfoDisplay
                    themeInfoDisplay
                }
            }
            Spacer()
        }
    }
}

struct InstructionView_Previews: PreviewProvider {
    static var previews: some View {
        InstructionView()
    }
}
