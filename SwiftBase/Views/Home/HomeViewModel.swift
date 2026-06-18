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

    /// Show the `interHome` interstitial, then navigate. The SDK throttles by
    /// `intervalShowInter`, so rapid taps won't stack ads; if disabled, the
    /// callback fires immediately and we just navigate.
    func openItem(_ id: Int) {
        InterHomeUtil.instance.show(placement: .home) { [weak self] in
            self?.app.navi.push(.homeDetail(id: id))
        }
    }
}
