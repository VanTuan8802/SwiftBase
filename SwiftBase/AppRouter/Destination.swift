//
//  Destination.swift
//  SwiftBase
//
//  Created by VanTuan on 18/6/26.
//

import SwiftUI

enum Destination: Equatable {
    static func == (lhs: Destination, rhs: Destination) -> Bool {
        String(describing: lhs) == String(describing: rhs)
    }

    case home
    case search
    case favorites
    case settings
    case homeDetail(id: Int)
    case language
}

extension Destination {
    var identifier: String {
        switch self {
        case .home:               return "home"
        case .search:             return "search"
        case .favorites:          return "favorites"
        case .settings:           return "settings"
        case .homeDetail(let id): return "homeDetail-\(id)"
        case .language:           return "language"
        }
    }
}

extension Navigation {
    @ViewBuilder
    internal func screen(for destinationWrapper: DestinationWrapper) -> some View {
        switch destinationWrapper.destination {
        case .home:
            HomeScreen()
        case .search:
            SearchScreen()
        case .favorites:
            FavoritesScreen()
        case .settings:
            SettingsScreen()
        case .homeDetail(let id):
            HomeDetailScreen(id: id)
        case .language:
            LanguageView(mode: .settings)
        }
    }
}
