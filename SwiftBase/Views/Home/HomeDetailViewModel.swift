//
//  HomeDetailViewModel.swift
//  SwiftBase
//
//  Created by VanTuan on 18/6/26.
//

import Foundation
import Factory

@MainActor
final class HomeDetailViewModel: ObservableObject {
    @Injected(\.app) private var app

    let id: Int

    init(id: Int) {
        self.id = id
    }

    func goBack() {
        app.navi.pop()
    }

    func openNext() {
        app.navi.push(.homeDetail(id: id + 1))
    }

    func goToTop() {
        app.navi.popToRoot(.root)
    }
}
