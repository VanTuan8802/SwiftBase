//
//  SearchViewModel.swift
//  SwiftBase
//
//  Created by VanTuan on 18/6/26.
//

import Foundation
import Factory

@MainActor
final class SearchViewModel: ObservableObject {
    @Injected(\.app) private var app

    @Published var query: String = ""

    var emptyStateTitle: String {
        query.isEmpty ? "start_typing".localized : String(format: "no_results_for".localized, query)
    }

    // Example of how a result tap would navigate:
    // func openResult(id: Int) { app.navi.push(.homeDetail(id: id)) }
}
