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

    /// Back via the in-screen button shows the `interBack` interstitial first.
    /// (The system swipe-back gesture is unaffected — only this button.)
    func goBack() {
        InterHomeUtil.instance.show(placement: .back) { [weak self] in
            self?.app.navi.pop()
        }
    }

    func openNext() {
        InterHomeUtil.instance.show(placement: .home) { [weak self] in
            guard let self else { return }
            self.app.navi.push(.homeDetail(id: self.id + 1))
        }
    }

    func goToTop() {
        app.navi.popToRoot(.root)
    }
}
