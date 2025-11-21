//
//  DeadSetAppApp.swift
//  DeadSetApp
//
//  Created on 2025-01-13.
//

import SwiftUI
import UIKit

// AppDelegate class that conforms to UIApplicationDelegate protocol
class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication,
                    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        // Configure Firebase or other services here if needed
        return true
    }

    // Add other UIApplicationDelegate methods as needed
    func application(_ application: UIApplication,
                    configurationForConnecting connectingSceneSession: UISceneSession,
                    options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        let sceneConfig = UISceneConfiguration(name: nil, sessionRole: connectingSceneSession.role)
        sceneConfig.delegateClass = nil
        return sceneConfig
    }
}

@main
struct DeadSetAppApp: App {
    // Integrate AppDelegate with SwiftUI lifecycle
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

    // Authentication manager
    @StateObject private var authManager = AuthenticationManager()

    var body: some Scene {
        WindowGroup {
            if authManager.isAuthenticated {
                ContentView()
                    .environmentObject(authManager)
            } else {
                AuthenticationView(authManager: authManager)
            }
        }
    }
}
