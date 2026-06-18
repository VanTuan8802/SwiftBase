//
//  HomeTab.swift
//  SwiftBase
//
//  Created by VanTuan on 18/6/26.
//

import Foundation

enum HomeTab: Hashable, CaseIterable {
    case home
    case search
    case favorites
    case settings

    var title: String {
        switch self {
        case .home:      return "home".localized
        case .search:    return "search".localized
        case .favorites: return "favorites".localized
        case .settings:  return "settings".localized
        }
    }

    /// SF Symbol name for the tab bar item.
    var icon: String {
        switch self {
        case .home:      return "house.fill"
        case .search:    return "magnifyingglass"
        case .favorites: return "heart.fill"
        case .settings:  return "gearshape.fill"
        }
    }
}
