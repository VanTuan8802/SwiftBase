//
//  HomeScreen.swift
//  SwiftBase
//
//  Created by VanTuan on 18/6/26.
//

import SwiftUI
import Factory

struct HomeScreen: View {
    @StateObject private var viewModel = HomeViewModel()
    // Observe the language so localized text re-reads `.localized` at runtime.
    @InjectedObject(\.appFlow) private var appFlow: AppFlowCoordinator

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text("home".localized)
                .font(.largeTitle.bold())
                .padding(.horizontal)
                .padding(.top, 8)

            List(viewModel.items, id: \.self) { id in
                Button {
                    viewModel.openItem(id)
                } label: {
                    Label(String(format: "item_number".localized, id), systemImage: "doc.text")
                }
            }
            .listStyle(.plain)
        }
        .trackScreen(.home)
    }
}


