//
//  AuthenticationView.swift
//  NinjaWarriors
//
//  Created by Muhammad Reyaaz on 13/3/24.
//

import SwiftUI

struct AuthenticationView: View {
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                Spacer(minLength: 0)
                NavigationLink(destination: SinglePlayerLobbyView().navigationBarBackButtonHidden(true)) {
                    Text("Single player")
                        .foregroundColor(.black)
                        .frame(maxWidth: .infinity)
                        .frame(width: 300, height: 55)
                        .background(Color.white)
                        .cornerRadius(10)
                }.padding()
                NavigationLink(destination: SignInView().navigationBarBackButtonHidden(true)) {
                    Text("Multiplayer")
                        .foregroundColor(.black)
                        .frame(maxWidth: .infinity)
                        .frame(width: 300, height: 55)
                        .background(Color.white)
                        .cornerRadius(10)
                }.padding()
                Spacer(minLength: 0)
            }
            .navigationBarTitle("Sign In")
            .navigationBarHidden(true)
            .background(
                Image("lobby-bg")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .edgesIgnoringSafeArea(.all)
                    .frame(width: Constants.screenWidth, height: Constants.screenHeight)
            )
        }.navigationViewStyle(.stack)
    }
}

struct AuthenticationView_Previews: PreviewProvider {
    static var previews: some View {
        AuthenticationView()
    }
}
