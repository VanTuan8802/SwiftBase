//
//  SettingsViewModel.swift
//  SwiftBase
//
//  Created by VanTuan on 18/6/26.
//

import Foundation
import Factory

@MainActor
final class SettingsViewModel: ObservableObject {
    @Injected(\.appFlow) private var flow

    let appName = "SwiftBase"
    let appVersion = "1.0.0"

    func replayOnboarding() {
        flow.resetOnboarding()
    }
}
