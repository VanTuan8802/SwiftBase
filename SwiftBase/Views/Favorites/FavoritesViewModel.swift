//
//  FavoritesViewModel.swift
//  SwiftBase
//
//  Created by VanTuan on 18/6/26.
//

import Foundation
import Factory

@MainActor
final class FavoritesViewModel: ObservableObject {
    @Injected(\.app) private var app

    @Published var items: [Int] = []

    var isEmpty: Bool { items.isEmpty }
}
