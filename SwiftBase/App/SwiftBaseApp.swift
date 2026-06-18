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
    }
}
