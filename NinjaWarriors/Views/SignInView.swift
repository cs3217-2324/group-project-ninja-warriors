//
//  SignInView.swift
//  NinjaWarriors
//
//  Created by Muhammad Reyaaz on 13/3/24.
//

import SwiftUI

struct SignInView: View {
    @StateObject private var viewModel = SignInViewModel(authentication: AuthenticationAdapter())
    @State private var loggedIn = false

    var body: some View {
        NavigationView {
            VStack {
                TextField("Email...", text: $viewModel.email)
                    .padding()
                    .background(Color.gray.opacity(0.4))
                    .cornerRadius(10)

                SecureField("Password...", text: $viewModel.password)
                    .padding()
                    .background(Color.gray.opacity(0.4))
                    .cornerRadius(10)

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
                        .foregroundColor(.white)
                        .frame(height: 55)
                        .frame(maxWidth: .infinity)
                        .background(Color.blue)
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
                        .background(Color.blue)
                        .cornerRadius(10)
                }

                Spacer()
            }
            .padding()
            .navigationTitle("Sign In With Email")
            .background(
                NavigationLink(
                    destination: LobbyView(),
                    isActive: $loggedIn,
                    label: { EmptyView() }
                )
            )
        }.navigationViewStyle(.stack)
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
