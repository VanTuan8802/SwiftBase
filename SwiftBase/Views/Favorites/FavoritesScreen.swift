//
//  FavoritesScreen.swift
//  SwiftBase
//
//  Created by VanTuan on 18/6/26.
//

import SwiftUI
import Factory

struct FavoritesScreen: View {
    @StateObject private var viewModel = FavoritesViewModel()
    // Observe the language so localized text re-reads `.localized` at runtime.
    @InjectedObject(\.appFlow) private var appFlow: AppFlowCoordinator

    var body: some View {
        VStack(spacing: 16) {
            Text("favorites".localized)
                .font(.largeTitle.bold())
                .frame(maxWidth: .infinity, alignment: .leading)
            Spacer()
            if viewModel.isEmpty {
                VStack(spacing: 12) {
                    Image(systemName: "heart")
                        .font(.system(size: 44))
                        .foregroundStyle(.secondary)
                    Text("nothing_saved_yet".localized)
                        .font(.headline)
                        .foregroundStyle(.secondary)
                }
            }
            Spacer()
        }
        .padding()
        .trackScreen(.favorites)
    }
}
