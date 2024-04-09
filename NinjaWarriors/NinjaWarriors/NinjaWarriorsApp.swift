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
            //HostView(matchId: "kDSNQZKqoRDI4vmAlGk2", currPlayerId: "lWgnfO6vrAZdeWa1aVThWzBLASr2")

            //ClientView(matchId: "xJqd5m90w2NOJZoSQXUS", currPlayerId: "lWgnfO6vrAZdeWa1aVThWzBLASr2")

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
