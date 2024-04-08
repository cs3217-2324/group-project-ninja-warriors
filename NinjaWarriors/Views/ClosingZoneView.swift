//
//  ClosingZoneView.swift
//  NinjaWarriors
//
//  Created by Jivesh Mohan on 3/4/24.
//

import SwiftUI

/// should display a transparent blue overlay over the entire screen except for a circle with center and point which has no overlay
struct ClosingZoneView: View {
    var circleCenter: CGPoint
    var circleRadius: CGFloat

    var body: some View {
        ZStack {
            Rectangle()
                .fill(Color.blue.opacity(0.2))
                .edgesIgnoringSafeArea(.all)
            Circle()
                .fill(Color.blue)
                .blendMode(.destinationOut)
                .frame(width: circleRadius * 2, height: circleRadius * 2)
                .position(circleCenter)
        }.compositingGroup()
    }
}
