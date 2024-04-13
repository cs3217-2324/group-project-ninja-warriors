//
//  ObjectDisplayView.swift
//  Peggle
//
//  Created by Muhammad Reyaaz on 29/2/24.
//

import SwiftUI

struct ObjectDisplayView: View {
    @State private var currentImageIndex = 0
    private let reappearImages: [String] = ["reappearObject", "reappearObjectActive"]
    private let actionImages: [String] = ["actionObject", "actionObjectActive"]
    private let oscillateImages: [String] = ["oscillateObject", "oscillateObjectActive"]
    private let powerText = "The special objects are Spook, Kaboom, and Oscillate."
    private let infoWidth: CGFloat = Constants.screenWidth / 12
    private let textWidth: CGFloat = Constants.screenWidth / 3

    var body: some View {
        VStack {
            HStack {
                objectDisplay(with: reappearImages)
                objectDisplay(with: actionImages)
                objectDisplay(with: oscillateImages)
            }
            Text(powerText)
                .font(.system(size: 20, weight: .bold))
                .lineLimit(nil)
                .frame(width: textWidth)
        }
    }
}

extension ObjectDisplayView {
    private func objectDisplay(with images: [String]) -> some View {
        Image(images[currentImageIndex])
            .resizable()
            .frame(width: infoWidth, height: infoWidth)
            .onAppear {
                Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
                    currentImageIndex = (currentImageIndex + 1) % 2
                }
            }
    }
}
