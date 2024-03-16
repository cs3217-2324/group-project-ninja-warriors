//
//  LobbyView.swift
//  NinjaWarriors
//
//  Created by Muhammad Reyaaz on 16/3/24.
//

import Foundation
import SwiftUI

struct LobbyView: View {
    @ObservedObject var viewModel = LobbyViewModel()
    @EnvironmentObject var signInViewModel: SignInViewModel

    var body: some View {
        VStack {
            if let user = signInViewModel.user {
                Text("UID: \(user.uid)")
                    .padding()
                Text("Email: \(user.email ?? "N/A")")
                    .padding()
            }
        }.environmentObject(signInViewModel)
    }
}
