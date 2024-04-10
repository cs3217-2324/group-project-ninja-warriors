//
//  IntroDisplayView.swift
//  Peggle
//
//  Created by Muhammad Reyaaz on 29/2/24.
//

import SwiftUI

struct IntroDisplayView: View {
    private let base = "base"
    private let intro = "How To Play"
    private let fontSize: CGFloat = 20

    var body: some View {
        ZStack {
            Image(base)
            Text(intro)
                .font(.system(size: fontSize, weight: .bold))
        }
    }
}
