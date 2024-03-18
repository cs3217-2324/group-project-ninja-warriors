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
                NavigationLink(destination: SignInView()) {
                    Text("Sign In With Email")
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 55)
                        .background(Color.blue)
                        .cornerRadius(10)
                }.padding()
                Spacer(minLength: 0)
            }
            .navigationBarTitle("Sign In")
            .navigationBarHidden(true)
        }.navigationViewStyle(.stack)
    }
}

struct AuthenticationView_Previews: PreviewProvider {
    static var previews: some View {
        AuthenticationView()
    }
}
