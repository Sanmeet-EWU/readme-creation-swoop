//
//  SwoopHealthApp.swift
//  SwoopHealth
//
//  Created by Jacob Lucas on 7/10/24.
//

import SwiftUI
import FirebaseCore

class AppDelegate: NSObject, UIApplicationDelegate {
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
    FirebaseApp.configure()

    return true
  }
}

@main
struct SwoopHealthApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    @AppStorage("user_id") var currentUserID: String?
    var body: some Scene {
        WindowGroup {
            NavigationView {
                if let userID = currentUserID {
                    MainView()
                } else {
                    OpeningView()
                }
            }
        }
    }
}
