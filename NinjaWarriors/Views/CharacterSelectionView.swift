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
        ZStack(alignment: .center) {
            VStack {
                Spacer()
                Image(viewModel.character)
                    .resizable()
                    .scaledToFit()
                    .scaleEffect(0.7)
                    .edgesIgnoringSafeArea(.all)
                LazyVGrid(columns: Array(repeating: GridItem(), count: 4), spacing: 10) {
                    ForEach(0..<8) { index in

                        VStack {
                            Image(characterNames[index])
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 100, height: 100)
                                .padding(5)
                                .foregroundColor(.blue)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 10)
                                        .stroke(selectedBox == index ? Color.red : Color.gray, lineWidth: 4)
                                ).onTapGesture {
                                    selectedBox = index
                                    viewModel.character = characterNames[index]
                                    AudioManager.shared.playButtonClickAudio()
                                }
                            Text("\(characterNames[index])")
                                .font(.system(size: 16, weight: .bold, design: .monospaced))
                                .foregroundColor(selectedBox == index ? .red : .white)
                                .textCase(.uppercase)
                        }
                    }
                }
                .padding()
                .background(Color.black.opacity(0.8))
                .cornerRadius(15)
            }
            if let selectedBox = selectedBox {
                VStack {
                    Text("YOU ARE")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding(.top, 20)
                    Text("\(characterNames[selectedBox])")
                        .font(.custom("KARASHA", size: 50))
                        .foregroundColor(.white)
                    Text(skills[characterNames[selectedBox]]?.joined(separator: ", ") ?? "")
                        .font(.headline)
                        .foregroundColor(.gray)
                        .padding(.bottom, 20)
                    Spacer()
                }
            } else {
                VStack {
                    Text(viewModel.character)
                        .font(.custom("KARASHA", size: 50))
                        .foregroundColor(.white)
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

struct CharacterSelectionView_Previews: PreviewProvider {
    static var previews: some View {
        CharacterSelectionView(viewModel: SingleLobbyViewModel())
            .environmentObject(AudioManager.shared)
    }
}
