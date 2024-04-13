//
//  InfoDisplayBoxView.swift
//  Peggle
//
//  Created by Muhammad Reyaaz on 29/2/24.
//

import SwiftUI

struct InfoDisplayBoxView: View {
    private let infoWidth: CGFloat = Constants.screenWidth / 3
    private let infoHeight: CGFloat = Constants.screenWidth / 3
    private let desertDarkBrown = Color(red: 195 / 255, green: 169 / 255, blue: 114 / 255)
    private let radius: CGFloat = 10
    private let opacity: CGFloat = 0.6

    var body: some View {
        ZStack {
            Rectangle()
                .frame(width: infoWidth, height: infoHeight)
                .foregroundColor(desertDarkBrown)
                .shadow(color: Color.black.opacity(opacity), radius: radius, x: radius, y: radius)
        }
    }
}
