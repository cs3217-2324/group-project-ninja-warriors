//
//  MapSelectionView.swift
//  NinjaWarriors
//
//  Created by Muhammad Reyaaz on 12/4/24.
//

import Foundation
import SwiftUI

struct MapSelectionView<Model>: View where Model: MapSelection {
    @State private var selectedImageIndex: Int?
    @ObservedObject var viewModel: Model
    var maps: [Map] = [ClosingZoneMap(), GemMap()]

    init(viewModel: Model) {
        self.viewModel = viewModel
    }

    var body: some View {
        VStack {
            Spacer()

            Text("Choose a map")
                .font(.custom("Avenir Next", size: 50))
                .fontWeight(.bold)
                .foregroundColor(.white)
                .padding(.top, 20)

            HStack(spacing: 30) {
                ForEach(0..<2) { index in
                    MapSelectionItemView(imageName: index == 0 ? "grass-stone" : "gray-wall",
                                         mapName: index == 0 ? "Closing Zone Mode" : "Gem Mode")
                    .onTapGesture {
                        selectedImageIndex = index
                        viewModel.map = maps[index]
                    }
                    .background(
                        ZStack {
                            Color.clear
                                .border(selectedImageIndex == index ? Color.white : Color.clear, width: 4)
                        }
                    )
                }
            }
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(
            Image("map-bg")
                .resizable()
                .edgesIgnoringSafeArea(.all)
                .scaledToFill()
                .blur(radius: 8.0)
        )
        .ignoresSafeArea()
    }
}

struct MapSelectionItemView: View {
    let imageName: String
    let mapName: String

    var body: some View {
        ZStack(alignment: .bottom) {
            Image(imageName)
                .resizable()
                .frame(width: 350, height: 350)
                .padding(10)

            Text(mapName)
                .font(.custom("Avenir Next", size: 20))
                .fontWeight(.bold)
                .foregroundColor(.white)
                .padding(.bottom, 20)
                .padding(.top, 20)
                .frame(maxWidth: .infinity, alignment: .bottom)
                .background(Color.black.opacity(0.5))
                .frame(width: 350)
                .padding(.horizontal)

        }
    }
}
