//
//  SwiftBaseApp.swift
//  SwiftBase
//
//  Created by VanTuan on 18/6/26.
//

import SwiftUI

@main
struct SwiftBaseApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) private var appDelegate

    var body: some Scene {
        WindowGroup {
            ContainerView()
        }
        // Mute app-open ads when the user leaves to Safari / App Store and
        // returns — otherwise the app-open ad fires on resume, which is jarring.
        .environment(\.openURL, OpenURLAction { _ in
            AdUtil.suppressAdsUntilReturn()
            return .systemAction
        })
    }
}
