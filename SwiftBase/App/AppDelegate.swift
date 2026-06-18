//
//  AppDelegate.swift
//  SwiftBase
//
//  Created by VanTuan on 18/6/26.
//


import UIKit

final class AppDelegate: NSObject, UIApplicationDelegate {

    // MARK: - Launch

    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil
    ) -> Bool {
        // One-time startup work goes here (analytics, crash reporting, etc.).
        return true
    }

    // MARK: - Scene configuration

    func application(
        _ application: UIApplication,
        configurationForConnecting connectingSceneSession: UISceneSession,
        options: UIScene.ConnectionOptions
    ) -> UISceneConfiguration {
        UISceneConfiguration(name: nil, sessionRole: connectingSceneSession.role)
    }

    // MARK: - Remote notifications

    func application(
        _ application: UIApplication,
        didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data
    ) {
        let token = deviceToken.map { String(format: "%02x", $0) }.joined()
        #if DEBUG
        print("[AppDelegate] APNs device token: \(token)")
        #endif
    }

    func application(
        _ application: UIApplication,
        didFailToRegisterForRemoteNotificationsWithError error: Error
    ) {
        #if DEBUG
        print("[AppDelegate] Failed to register for remote notifications: \(error)")
        #endif
    }
}
