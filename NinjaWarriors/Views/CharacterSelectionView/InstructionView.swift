//
//  InstructionView.swift
//  Peggle
//
//  Created by Muhammad Reyaaz on 29/2/24.
//

import SwiftUI

struct InstructionView: View {
    @State private var selectedBox: Int? = nil

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
                                                        .foregroundColor(.blue) // You can change color as needed
                                                        .overlay(
                                                            RoundedRectangle(cornerRadius: 10)
                                                                .stroke(Color.black, lineWidth: 1)
                                                        ).onTapGesture {
                                                            selectedBox = index
                                                        }



                           

                        }
                    }
                    .padding()
                    .background(Color.gray.opacity(0.2)) // Background color
                    .cornerRadius(15)
                    .padding() // Adjust padding as needed
                }

                // Display text centered above the grid
                if let selectedBox = selectedBox {
                    Text("Box \(selectedBox + 1)")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.black.opacity(0.7))
                        .clipShape(Capsule())
                        .transition(.scale)
                }
            }
        }
    }
}


struct InstructionView_Previews: PreviewProvider {
    static var previews: some View {
        InstructionView()
    }
}
