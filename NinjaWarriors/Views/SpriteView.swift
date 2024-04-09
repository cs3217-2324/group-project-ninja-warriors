//
//  SpriteView.swift
//  NinjaWarriors
//
//  Created by Muhammad Reyaaz on 28/3/24.
//

import Foundation
import SwiftUI

struct SpriteView: View {
    @State var renderedImage: Image
    @Binding var position: CGPoint

    var body: some View {
        //if let position = position {
            renderedImage
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 50, height: 50)
                .position(position)
        //}
    }
}
