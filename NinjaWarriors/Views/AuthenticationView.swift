//
//  AuthenticationView.swift
//  NinjaWarriors
//
//  Created by Muhammad Reyaaz on 13/3/24.
//

import SwiftUI

struct AuthenticationView: View {
    @State private var path = NavigationPath()

    private let destinationMap: [String: (Binding<NavigationPath>) -> AnyView] = [
        "SingleLobbyView": { path in AnyView(SingleLobbyView(path: path)) },
        "SignInView": { path in AnyView(SignInView(path: path)) },
        "LobbyView": { path in AnyView(LobbyView(path: path)) },
        "HowToPlayView": { _ in AnyView(HowToPlayView()) }
    ]

    var body: some View {
        NavigationStack(path: $path) {
            VStack(spacing: 5) {
                Spacer(minLength: 0)
                NavigationLink("Single Player", value: "SingleLobbyView")
                    .font(.custom("KARASHA", size: 30))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .frame(width: 322, height: 96)
                    .background(Image("button-bg"))
                    .cornerRadius(10)
                    .padding()
                    .simultaneousGesture(TapGesture().onEnded {
                        AudioManager.shared.playButtonClickAudio()
                    })
                NavigationLink("Multiplayer Account", value: "SignInView")
                    .font(.custom("KARASHA", size: 30))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .frame(width: 322, height: 96)
                    .background(Image("button-bg"))
                    .cornerRadius(10)
                    .padding()
                    .simultaneousGesture(TapGesture().onEnded {
                        AudioManager.shared.playButtonClickAudio()
                    })
                NavigationLink("Multiplayer Guest", value: "LobbyView")
                    .font(.custom("KARASHA", size: 30))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .frame(width: 322, height: 96)
                    .background(Image("button-bg"))
                    .cornerRadius(10)
                    .padding()
                    .simultaneousGesture(TapGesture().onEnded {
                        AudioManager.shared.playButtonClickAudio()
                    })
                NavigationLink("How To Play", value: "HowToPlayView")
                    .font(.custom("KARASHA", size: 30))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .frame(width: 322, height: 96)
                    .background(Image("button-bg"))
                    .cornerRadius(10)
                    .padding()
                    .simultaneousGesture(TapGesture().onEnded {
                        AudioManager.shared.playButtonClickAudio()
                    })
                Spacer(minLength: 0)
            }
            .navigationDestination(for: String.self) { destination in
                destinationMap[destination]?($path) ?? AnyView(EmptyView())
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
