//
//  SearchScreen.swift
//  SwiftBase
//
//  Created by VanTuan on 18/6/26.
//

import SwiftUI
import Factory

struct SearchScreen: View {
    @StateObject private var viewModel = SearchViewModel()
    // Observe the language so localized text re-reads `.localized` at runtime.
    @InjectedObject(\.appFlow) private var appFlow: AppFlowCoordinator

    var body: some View {
        VStack(spacing: 16) {
            Text("search".localized)
                .font(.largeTitle.bold())
                .frame(maxWidth: .infinity, alignment: .leading)

            HStack {
                Image(systemName: "magnifyingglass")
                    .foregroundStyle(.secondary)
                TextField("search_placeholder".localized, text: $viewModel.query)
            }
            .cardSurface()

            Spacer()
            ContentUnavailableViewCompat(
                title: viewModel.emptyStateTitle,
                systemImage: "magnifyingglass"
            )
            Spacer()
        }
        .padding()
    }
}

/// Minimal stand-in so this compiles on iOS 16 (ContentUnavailableView is iOS 17+).
private struct ContentUnavailableViewCompat: View {
    let title: String
    let systemImage: String

    var body: some View {
        VStack(spacing: 12) {
            Image(systemName: systemImage)
                .font(.system(size: 44))
                .foregroundStyle(.secondary)
            Text(title)
                .font(.headline)
                .foregroundStyle(.secondary)
        }
    }
}
