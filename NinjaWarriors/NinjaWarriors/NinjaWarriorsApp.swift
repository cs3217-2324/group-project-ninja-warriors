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
            //RenderView(matchId: "iUEZL99TQ1gVAB9MwyA3", currPlayerId: "kn2Ap0BtgChusWyyHZtpV42RxmZ2")
            RenderView(matchId: "Yjda1z4JfpnpFhBsD1PH", currPlayerId: "lWgnfO6vrAZdeWa1aVThWzBLASr2")
            //RenderView(matchId: "2qfTVRvygyxIgY0TMAIW", currPlayerId: "qIcQpEfDVOQ1cOtvbv2LQMfvPIz2")
            //RenderView(matchId: "s8Mr8jHfE4TAjBOuA5tQ", currPlayerId: "Zzq85zzGsrVwumIIlEf0hexyEKv2")
            //AuthenticationView()
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
