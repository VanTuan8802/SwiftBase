//
//  SettingsScreen.swift
//  SwiftBase
//
//  Created by VanTuan on 18/6/26.
//

import SwiftUI

struct SettingsScreen: View {
    @StateObject private var viewModel = SettingsViewModel()
    @EnvironmentObject private var coordinator: AppFlowCoordinator
    @Environment(\.openURL) private var openURL

    var body: some View {
        VStack(spacing: 0) {
            BasicHeaderView("settings".localized)

            List {
                Section {
                    Button {
                        viewModel.openLanguage()
                    } label: {
                        HStack {
                            Label("language".localized, systemImage: "globe")
                            Spacer()
                            Text("\(coordinator.language.flag) \(coordinator.language.displayName)")
                                .foregroundStyle(.secondary)
                            Image(systemName: "chevron.right")
                                .font(.footnote.weight(.semibold))
                                .foregroundStyle(.tertiary)
                        }
                    }
                    .tint(.primary)

                    Button {
                        viewModel.rateApp()
                    } label: {
                        row("rate".localized, systemImage: "star.fill")
                    }
                    .tint(.primary)

                    ShareLink(item: viewModel.shareMessage) {
                        row("share".localized, systemImage: "square.and.arrow.up")
                    }
                    .tint(.primary)

                    Button {
                        if let url = viewModel.policyURL { openURL(url) }
                    } label: {
                        row("privacy_policy".localized, systemImage: "lock.shield.fill")
                    }
                    .tint(.primary)
                }
            }
        }
        .trackScreen(.settings)
    }

    /// A tappable settings row: leading icon + title, trailing chevron.
    private func row(_ title: String, systemImage: String) -> some View {
        HStack {
            Label(title, systemImage: systemImage)
            Spacer()
            Image(systemName: "chevron.right")
                .font(.footnote.weight(.semibold))
                .foregroundStyle(.tertiary)
        }
    }
}
