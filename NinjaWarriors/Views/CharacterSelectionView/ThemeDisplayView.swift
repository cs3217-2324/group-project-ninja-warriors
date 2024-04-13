//
//  ThemeDisplayView.swift
//  Peggle
//
//  Created by Muhammad Reyaaz on 29/2/24.
//

import SwiftUI

struct ThemeDisplayView: View {
    private let infoWidth: CGFloat = Constants.screenWidth / 3
    private let obstacleText = "Ancient Egypt-themed objects!"

    var body: some View {
        VStack {
            HStack {
                SharpDisplayView()
                ObstacleDisplayView()
            }
            Text(obstacleText)
                .font(.system(size: 20, weight: .bold))
                .lineLimit(nil)
                .frame(width: infoWidth)
        }
    }
}
