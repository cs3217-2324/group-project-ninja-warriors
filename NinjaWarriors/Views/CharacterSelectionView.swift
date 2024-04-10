//
//  CharacterSelectionView.swift
//  Peggle
//
//  Created by Muhammad Reyaaz on 29/2/24.
//

import SwiftUI

struct CharacterSelectionView: View {
    @State private var selectedBox: Int? = nil
    @State private var characterNames: [String] = Constants.characterNames
    @State private var skills = Constants.skills

    var body: some View {
        NavigationStack {
            ZStack(alignment: .top) {
                VStack {
                    if let selectedBox = selectedBox {
                        Image(characterNames[selectedBox])
                            .resizable()
                            .scaledToFit()
                            .scaleEffect(0.7)
                            .edgesIgnoringSafeArea(.all)
                    }
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
                                                                .stroke(Color.black, lineWidth: 1)
                                                        ).onTapGesture {
                                                            selectedBox = index
                                                        }
                        }
                    }
                    .padding()
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(15)
                }
                if let selectedBox = selectedBox {
                    VStack {
                        Text("\(characterNames[selectedBox])")
                            .font(.custom("YourFontName", size: 40))
                            .foregroundColor(.black)
                            .padding(.top, 20)
                        Text(skills[characterNames[selectedBox]]?.joined(separator: ", ") ?? "")
                            .font(.headline)
                            .foregroundColor(.gray)
                            .padding(.bottom, 20)
                        Spacer()
                    }
                }
            }
        }
    }
}


struct CharacterSelectionView_Previews: PreviewProvider {
    static var previews: some View {
        CharacterSelectionView()
    }
}
