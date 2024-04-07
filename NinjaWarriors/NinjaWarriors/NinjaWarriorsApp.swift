//
//  NinjaWarriorsApp.swift
//  NinjaWarriors
//
//  Created by Muhammad Reyaaz on 13/3/24.
//

import SwiftUI
import FirebaseCore

@main
struct NinjaWarriorsApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate

    var body: some Scene {
        WindowGroup {
            // TODO: Remove after testing

            //HostView(matchId: "5NjVOKbhQrXDnlcmeVpE", currPlayerId: "lWgnfO6vrAZdeWa1aVThWzBLASr2")

            //ClientView(matchId: "5NjVOKbhQrXDnlcmeVpE", currPlayerId: "lWgnfO6vrAZdeWa1aVThWzBLASr2")

            AuthenticationView()
        }
    }
}

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions:
    [UIApplication.LaunchOptionsKey: Any]? = nil) -> Bool {
        FirebaseApp.configure()
        return true
    }
}
