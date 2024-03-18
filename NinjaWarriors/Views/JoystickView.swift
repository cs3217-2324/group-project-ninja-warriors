//
//  JoystickView.swift
//  NinjaWarriors
//
//  Created by proglab on 17/3/24.
//

import SwiftUI

struct JoystickView: View {
    @State private var location: CGPoint = .zero
    @State private var innerCircleLocation: CGPoint = .zero
    @GestureState private var fingerLocation: CGPoint?

    private let bigCircleRadius: CGFloat = 100 // Adjust the radius of the blue circle

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
            }
            .updating($fingerLocation) { (value, fingerLocation, _) in
                fingerLocation = value.location
            }
            .onEnded {_ in
                // Snap the smaller circle to the center of the larger circle
                let center = location
                innerCircleLocation = center
            }
    }

    var body: some View {
        ZStack {
            // Larger circle (blue circle)
            Circle()
                .foregroundColor(.blue)
                .frame(width: bigCircleRadius * 2, height: bigCircleRadius * 2)
                .position(location)

            // Smaller circle (green circle)
            Circle()
                .foregroundColor(.green)
                .frame(width: 50, height: 50)
                .position(innerCircleLocation)
                .gesture(fingerDrag)
        }
    }
}
