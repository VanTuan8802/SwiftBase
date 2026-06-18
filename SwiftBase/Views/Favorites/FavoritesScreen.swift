//
//  FavoritesScreen.swift
//  SwiftBase
//
//  Created by VanTuan on 18/6/26.
//

import SwiftUI
import Factory

struct FavoritesScreen: View {
    // Observe the language so the header re-reads `.localized` at runtime.
    @InjectedObject(\.appFlow) private var appFlow: AppFlowCoordinator

    var body: some View {
        VStack(spacing: 0) {
            BasicHeaderView("favorites".localized)
            Spacer()
        }
        .trackScreen(.favorites)
    }
}
