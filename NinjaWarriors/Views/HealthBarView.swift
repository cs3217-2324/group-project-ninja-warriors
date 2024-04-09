//
//  HealthBarView.swift
//  NinjaWarriors
//
//  Created by Muhammad Reyaaz on 22/3/24.
//

import Foundation
import SwiftUI

var healthBarView: some View {
    ZStack(alignment: .topLeading) {
        RoundedRectangle(cornerRadius: radius)
            .frame(width: width, height: height)
            .foregroundColor(.gray)
        RoundedRectangle(cornerRadius: radius)
            .frame(width: CGFloat(health / 2), height: height)
            .foregroundColor(.green)
        Text("\(Int(health))/100")
            .font(.system(size: fontSize))
            .foregroundColor(.white)
            .padding(radius)
        CirclesOverlay(
            isDisplay: isShowingCircle,
            name: imageName,
            diameter: diameter,
            isAnimating: $isAnimating
        )
    }
}
