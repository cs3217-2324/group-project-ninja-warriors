//
//  IconsView.swift
//  Peggle
//
//  Created by Muhammad Reyaaz on 29/2/24.
//

import SwiftUI

struct IconsView: View {
    private let infoWidth: CGFloat = Constants.screenWidth / 6
    private let infoHeight: CGFloat = Constants.screenWidth / 9
    private let hieroglyph = "hieroglyph"
    private let ankh = "ankh"
    private let horus = "horus"

    var body: some View {
        HStack {
            Image(hieroglyph)
                .resizable()
                .frame(width: infoWidth, height: infoWidth)
            Image(ankh)
                .resizable()
                .frame(width: infoWidth, height: infoWidth)
            Image(horus)
                .resizable()
                .frame(width: infoWidth, height: infoWidth)
        }
    }
}

struct IconsView_Previews: PreviewProvider {
    static var previews: some View {
        IconsView()
    }
}
