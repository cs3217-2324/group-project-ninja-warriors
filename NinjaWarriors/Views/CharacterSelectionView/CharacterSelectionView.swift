//
//  CharacterSelectionView.swift
//  Peggle
//
//  Created by Muhammad Reyaaz on 29/2/24.
//

import SwiftUI

struct CharacterSelectionView: View {
    @State private var selectedBox: Int? = nil
    @State private let characterNames: [String] = ["Shadowstrike", "Nightblade", "Swiftshadow", "SilentStorm", "Crimsonshadow", "Shadowblade", "Venomstrike", "Darkwind"]

    var body: some View {
        NavigationStack {
            ZStack(alignment: .top) {
                VStack {
                    Spacer()
                    LazyVGrid(columns: Array(repeating: GridItem(), count: 4), spacing: 1) {
                        ForEach(0..<8) { index in

                            Image(systemName: "person.circle.fill")
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
                        Text("Character Selection \(selectedBox)")
                            .font(.custom("YourFontName", size: 40))
                            .foregroundColor(.black)
                            .padding(.top, 20)

                        Spacer()

                        Text("Skills: Strength, Agility, Intelligence")
                            .font(.headline)
                            .foregroundColor(.gray)
                            .padding(.bottom, 20)
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
