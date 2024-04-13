//
//  SharpDisplayView.swift
//  Peggle
//
//  Created by Muhammad Reyaaz on 29/2/24.
//

import SwiftUI

struct SharpDisplayView: View {
    private let sharp = "sharpBlock"
    private let infoWidth: CGFloat = Constants.screenWidth / 9

    var body: some View {
        Image(sharp)
            .resizable()
            .frame(width: infoWidth, height: infoWidth)
    }
}
