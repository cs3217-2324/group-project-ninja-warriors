//
//  SignInView.swift
//  NinjaWarriors
//
//  Created by Muhammad Reyaaz on 13/3/24.
//

import SwiftUI

struct SignInView: View {
    @ObservedObject private var viewModel = SignInViewModel(authentication: AuthenticationAdapter())
    @State private var loggedIn = false

    var body: some View {
        NavigationView {
            VStack {
                Spacer()
                TextField("Email...", text: $viewModel.email)
                    .padding()
                    .foregroundColor(.black)
                    .background(Color.white.opacity(0.7))
                    .cornerRadius(10)

                SecureField("Password...", text: $viewModel.password)
                    .padding()
                    .foregroundColor(.black)
                    .background(Color.white.opacity(0.7))
                    .cornerRadius(10)
                
                Divider()
                Button {
                    Task {
                        do {
                            try await viewModel.signUp()
                            loggedIn = true
                        } catch {
                            print(error)
                        }
                    }
                } label: {
                    Text("Sign Up")
                        .font(.headline)
                        .foregroundColor(.gray)
                        .frame(height: 55)
                        .frame(maxWidth: .infinity)
                        .background(Color.white)
                        .cornerRadius(10)
                }

                Button {
                    Task {
                        do {
                            try await viewModel.signIn()
                            loggedIn = true
                        } catch {
                            print(error)
                        }
                    }
                } label: {
                    Text("Sign In")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(height: 55)
                        .frame(maxWidth: .infinity)
                        .background(Color.purple)
                        .cornerRadius(10)
                }

                Spacer()
            }
            .padding()
            .frame(width: 500)
            .background(
                Image("lobby-bg")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .edgesIgnoringSafeArea(.all)
                    .frame(width: Constants.screenWidth, height: Constants.screenHeight)
            )
            .background(
                NavigationLink(
                    destination: LobbyView(viewModel: LobbyViewModel(signInViewModel: viewModel)),
                    isActive: $loggedIn,
                    label: { EmptyView() }
                )
            )
        }
        .navigationViewStyle(.stack)
        .navigationBarBackButtonHidden(true)
        .environmentObject(viewModel)
    }
}

struct SignInView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            SignInView()
        }
    }
}
