//
//  JoystickView.swift
//  NinjaWarriors
//
//  Created by proglab on 17/3/24.
//

import Foundation
import SwiftUI

struct JoystickView: View {
    @Binding var playerPosition: CGPoint
    @State var location: CGPoint
    @State var innerCircleLocation: CGPoint

    var setInputVector: (CGVector) -> Void
    let bigCircleRadius: CGFloat = 100
    var bigCircleDiameter: CGFloat {
        bigCircleRadius * 2
    }
    let smallCircleRadius: CGFloat = 25
    var smallCircleDiameter: CGFloat {
        smallCircleRadius * 2
    }

    init(playerPosition: Binding<CGPoint>, setInputVector: @escaping (CGVector) -> Void, location: CGPoint) {
        _playerPosition = playerPosition
        self.setInputVector = setInputVector
        self.location = location
        self.innerCircleLocation = location
    }

    var fingerDrag: some Gesture {
        DragGesture()
            .onChanged { value in
                updatePlayerPosition(with: value)
            }
            .onEnded { _ in
                // Snap the smaller circle to the center of the larger circle
                innerCircleLocation = location
                setInputVector(CGVector.zero)
            }
    }

    // Function to update player position
    private func updatePlayerPosition(with value: DragGesture.Value) {
        // Calculate the distance between the finger location and the center of the blue circle
        let distance = sqrt(pow(value.location.x - location.x, 2) + pow(value.location.y - location.y, 2))

        // Calculate the angle between the center of the blue circle and the finger location
        let angle = atan2(value.location.y - location.y, value.location.x - location.x)

        let maxDistance = bigCircleRadius

        // Clamp the distance within the blue circle
        let clampedDistance = min(distance, maxDistance)

        let newX = location.x + cos(angle) * clampedDistance
        let newY = location.y + sin(angle) * clampedDistance

        innerCircleLocation = CGPoint(x: newX, y: newY)

        // Set input vector
        let scaleFactor: CGFloat = 1
        let vector = CGVector(dx: (newX - location.x) * scaleFactor,
                              dy: (newY - location.y) * scaleFactor)

        // TODO: Perhaps set game control vector here rather than canvas view
        setInputVector(vector)

        // Update player position
        playerPosition = CGPoint(x: max(0, playerPosition.x + vector.dx),
                                 y: max(0, playerPosition.y + vector.dy))
    }

    var body: some View {
        ZStack {
            Circle()
                .strokeBorder(Color.blue, lineWidth: 4)
                .background(Circle().foregroundColor(Color.white.opacity(0.1)))
                .frame(width: bigCircleDiameter, height: bigCircleDiameter)
                .position(location)

            Circle()
                .foregroundColor(.blue)
                .frame(width: smallCircleDiameter, height: smallCircleDiameter)
                .position(innerCircleLocation)
                .gesture(fingerDrag)
        }
    }
}
