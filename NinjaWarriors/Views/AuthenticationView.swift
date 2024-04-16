//
//  AuthenticationView.swift
//  NinjaWarriors
//
//  Created by Muhammad Reyaaz on 13/3/24.
//

import SwiftUI

struct AuthenticationView: View {
    @State private var path = NavigationPath()

    var body: some View {
        NavigationStack(path: $path) {
            VStack(spacing: 20) {
                Spacer(minLength: 0)
                NavigationLink("Single Player", value: "SingleLobbyView")
                    .foregroundColor(.black)
                    .frame(maxWidth: .infinity)
                    .frame(width: 300, height: 55)
                    .background(Color.white)
                    .cornerRadius(10)
                    .padding()
                NavigationLink("Multiplayer Account", value: "SignInView")
                    .foregroundColor(.black)
                    .frame(maxWidth: .infinity)
                    .frame(width: 300, height: 55)
                    .background(Color.white)
                    .cornerRadius(10)
                    .padding()
                NavigationLink("Multiplayer Guest", value: "LobbyView")
                    .foregroundColor(.black)
                    .frame(maxWidth: .infinity)
                    .frame(width: 300, height: 55)
                    .background(Color.white)
                    .cornerRadius(10)
                    .padding()
                Spacer(minLength: 0)
            }
            .navigationDestination(for: String.self) { destination in
                if let destination = destination {
                    if destination == "SingleLobbyView" {
                        SingleLobbyView(path: $path)
                    } else if destination == "SignInView" {
                        SignInView(path: $path)
                    } else if destination == "LobbyView" {
                        LobbyView(path: $path)
                    } else {
                        EmptyView()
                    }
                } else {
                    EmptyView()
                }
            }
            .navigationTitle("Home")
            .background(
                Image("lobby-bg")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .edgesIgnoringSafeArea(.all)
                    .frame(width: Constants.screenWidth, height: Constants.screenHeight)
            )
        }
    }
}

struct AuthenticationView_Previews: PreviewProvider {
    static var previews: some View {
        AuthenticationView()
    }
}
