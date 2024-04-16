//
//  CharacterSelectionView.swift
//  NinjaWarriors
//
//  Created by Muhammad Reyaaz on 11/4/24.
//

import Foundation

import SwiftUI

struct CharacterSelectionView<Model>: View where Model: CharacterSelection {
    @State private var selectedBox: Int?
    @State private var characterNames: [String] = Constants.characterNames
    @State private var skills = Constants.skills
    @ObservedObject var viewModel: Model

    init(viewModel: Model) {
        self.viewModel = viewModel
    }

    var body: some View {
        NavigationStack {
            ZStack(alignment: .top) {
                VStack {
                    Image(viewModel.character)
                        .resizable()
                        .scaledToFit()
                        .scaleEffect(0.7)
                        .edgesIgnoringSafeArea(.all)
                    Spacer()
                    LazyVGrid(columns: Array(repeating: GridItem(), count: 4), spacing: 1) {
                        ForEach(0..<8) { index in

                            Image(characterNames[index])
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 50, height: 50)
                                .padding(5)
                                .foregroundColor(.blue)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 10)
                                        .stroke(Color.gray, lineWidth: 1)
                                ).onTapGesture {
                                    selectedBox = index
                                    viewModel.character = characterNames[index]
                                    AudioManager.shared.playButtonClickAudio()
                                }
                        }
                    }
                    .padding()
                    .background(Color.gray.opacity(0.8))
                    .cornerRadius(15)
                }
                if let selectedBox = selectedBox {
                    VStack {
                        Text("\(characterNames[selectedBox])")
                            .font(.custom("CustomFont", size: 40))
                            .foregroundColor(.gray)
                            .padding(.top, 20)
                        Text(skills[characterNames[selectedBox]]?.joined(separator: ", ") ?? "")
                            .font(.headline)
                            .foregroundColor(.gray)
                            .padding(.bottom, 20)
                        Spacer()
                    }
                } else {
                    VStack {
                        Text(viewModel.character)
                            .font(.custom("CustomFont", size: 40))
                            .foregroundColor(.gray)
                            .padding(.top, 20)
                        Text(skills[viewModel.character]?.joined(separator: ", ") ?? "")
                            .font(.headline)
                            .foregroundColor(.gray)
                            .padding(.bottom, 20)
                        Spacer()
                    }
                }
            }.background(
                Image("bg")
                    .resizable()
                    .edgesIgnoringSafeArea(.all)
                    .scaledToFill()
            )
        }
    }
}
