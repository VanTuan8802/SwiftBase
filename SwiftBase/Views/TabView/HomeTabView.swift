//
//  HomeTabView.swift
//  SwiftBase
//
//  Created by VanTuan on 18/6/26.
//

import SwiftUI
import Factory

struct HomeTabView: View {
    @InjectedObject(\.homeNavi) private var homeNavi: Navigation
    @InjectedObject(\.searchNavi) private var searchNavi: Navigation
    @InjectedObject(\.favoritesNavi) private var favoritesNavi: Navigation
    @InjectedObject(\.settingsNavi) private var settingsNavi: Navigation
    @InjectedObject(\.app) private var app: AppManager
    @EnvironmentObject private var coordinator: AppFlowCoordinator

    @State private var isFirstAppear = false

    var body: some View {
        // Observe the language so the tab titles re-read `.localized` when it
        // changes at runtime (e.g. from the Settings language sheet).
        let _ = coordinator.language
        return TabView(selection: $app.activeTab) {
            NavigationRoot(destination: .home, navigation: homeNavi)
                .tabItem { Label(HomeTab.home.title, systemImage: HomeTab.home.icon) }
                .tag(HomeTab.home)

            NavigationRoot(destination: .search, navigation: searchNavi)
                .tabItem { Label(HomeTab.search.title, systemImage: HomeTab.search.icon) }
                .tag(HomeTab.search)

            NavigationRoot(destination: .favorites, navigation: favoritesNavi)
                .tabItem { Label(HomeTab.favorites.title, systemImage: HomeTab.favorites.icon) }
                .tag(HomeTab.favorites)

            NavigationRoot(destination: .settings, navigation: settingsNavi)
                .tabItem { Label(HomeTab.settings.title, systemImage: HomeTab.settings.icon) }
                .tag(HomeTab.settings)
        }
        .onAppear {
            guard !isFirstAppear else { return }
            isFirstAppear = true
            app.navi = homeNavi
        }
        .onChange(of: app.activeTab) { tab in
            didSelectTab(tab)
        }
    }

    /// Keep `app.navi` pointing at the active tab's navigation tree.
    private func didSelectTab(_ tab: HomeTab) {
        switch tab {
        case .home:      app.navi = homeNavi
        case .search:    app.navi = searchNavi
        case .favorites: app.navi = favoritesNavi
        case .settings:  app.navi = settingsNavi
        }
    }
}

#if DEBUG
#Preview {
    HomeTabView()
        .environmentObject(AppFlowCoordinator())
}
#endif
