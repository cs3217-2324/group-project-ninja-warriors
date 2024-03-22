//
//  JoystickView.swift
//  NinjaWarriors
//
//  Created by proglab on 17/3/24.
//

import SwiftUI

struct JoystickView: View {
    @State private var location: CGPoint
    @State private var innerCircleLocation: CGPoint

    private var setInputVector: (CGVector) -> Void
    private let bigCircleRadius: CGFloat = 100
    private var bigCircleDiameter: CGFloat {
        bigCircleRadius * 2
    }
    private let smallCircleRadius: CGFloat = 25
    private var smallCircleDiameter: CGFloat {
        smallCircleRadius * 2
    }

    init(setInputVector: @escaping (CGVector) -> Void, location: CGPoint) {
        self.setInputVector = setInputVector
        self.location = location
        self.innerCircleLocation = location
    }

    var fingerDrag: some Gesture {
        DragGesture()
            .onChanged { value in
                // Calculate the distance between the finger location and the center of the blue circle
                let distance = sqrt(pow(value.location.x - location.x, 2) + pow(value.location.y - location.y, 2))

                // Calculate the angle between the center of the blue circle and the finger location
                let angle = atan2(value.location.y - location.y, value.location.x - location.x)

                // Calculate the maximum allowable distance within the blue circle
                let maxDistance = bigCircleRadius

                // Clamp the distance within the blue circle
                let clampedDistance = min(distance, maxDistance)

                // Calculate the new location at the edge of the blue circle
                let newX = location.x + cos(angle) * clampedDistance
                let newY = location.y + sin(angle) * clampedDistance

                innerCircleLocation = CGPoint(x: newX, y: newY)

                // Set input vector
                let vector = CGVector(dx: newX - location.x, dy: newY - location.y)
                setInputVector(vector)
            }
            .onEnded {_ in
                // Snap the smaller circle to the center of the larger circle
                innerCircleLocation = location
                setInputVector(CGVector.zero)
            }
    }

    var body: some View {
        ZStack {
            // Larger circle (blue circle)
            Circle()
                .foregroundColor(.blue)
                .frame(width: bigCircleDiameter, height: bigCircleDiameter)
                .position(location)

            // Smaller circle (green circle)
            Circle()
                .foregroundColor(.green)
                .frame(width: smallCircleDiameter, height: smallCircleDiameter)
                .position(innerCircleLocation)
                .gesture(fingerDrag)
        }
    }
}
