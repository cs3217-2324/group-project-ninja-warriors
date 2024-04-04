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
            //CanvasView(matchId: "2d1NvyaH3GKGtGOLUwHV", currPlayerId: "lWgnfO6vrAZdeWa1aVThWzBLASr2")

            //CanvasView(matchId: "1iKigKTtJz1JoLUxFkVr", currPlayerId: "lWgnfO6vrAZdeWa1aVThWzBLASr2")
            //CanvasView(matchId: "jZRiyvyjHIpvnAWdnmj0", currPlayerId: "lWgnfO6vrAZdeWa1aVThWzBLASr2")
            //CanvasView(matchId: "PkRyBoW0zgNTF9ktPb3d", currPlayerId: "lWgnfO6vrAZdeWa1aVThWzBLASr2")
            //CanvasView(matchId: "9GhnqE6FqN1tn4C27Wh4, currPlayerId: "lWgnfO6vrAZdeWa1aVThWzBLASr2")
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
