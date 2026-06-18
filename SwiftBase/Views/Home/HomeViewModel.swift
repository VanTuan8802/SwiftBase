//
//  HomeViewModel.swift
//  SwiftBase
//
//  Created by VanTuan on 18/6/26.
//

import Foundation
import Factory

@MainActor
final class HomeViewModel: ObservableObject {
    @Injected(\.app) private var app

    @Published var items: [Int] = Array(1...20)

    func openItem(_ id: Int) {
        app.navi.push(.homeDetail(id: id))
    }
}
