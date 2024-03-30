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
            //CanvasView(matchId: "oy3D5fA5M9ekwQycOrfj", currPlayerId: "lWgnfO6vrAZdeWa1aVThWzBLASr2")
            //CanvasView(matchId: "aTwImDd1xQPq5P32YgJ6", currPlayerId: "lWgnfO6vrAZdeWa1aVThWzBLASr2")
            //CanvasView(matchId: "EGBGdEcu0wBTjoCcNKcN", currPlayerId: "lWgnfO6vrAZdeWa1aVThWzBLASr2")
            //CanvasView(matchId: "bFrUBaoVzEQUPU5IsBLk, currPlayerId: "lWgnfO6vrAZdeWa1aVThWzBLASr2")
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
