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
    @State private var showLanguagePicker = false

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text("settings".localized)
                .font(.largeTitle.bold())
                .padding(.horizontal)
                .padding(.top, 8)

            List {
                Section("general".localized) {
                    Button {
                        showLanguagePicker = true
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
                }

                Section("about".localized) {
                    LabeledContent("app".localized, value: viewModel.appName)
                    LabeledContent("version".localized, value: viewModel.appVersion)
                }

                #if DEBUG
                Section("developer".localized) {
                    Button(role: .destructive) {
                        viewModel.replayOnboarding()
                    } label: {
                        Label("replay_onboarding".localized, systemImage: "arrow.counterclockwise")
                    }
                }
                #endif
            }
        }
        .sheet(isPresented: $showLanguagePicker) {
            LanguageView(mode: .settings)
        }
        .trackScreen(.settings)
    }
}
