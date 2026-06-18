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
    }
}

struct HomeDetailScreen: View {
    @StateObject private var viewModel: HomeDetailViewModel

    init(id: Int) {
        _viewModel = StateObject(wrappedValue: HomeDetailViewModel(id: id))
    }

    var body: some View {
        VStack(spacing: 20) {
            HStack {
                Button {
                    viewModel.goBack()
                } label: {
                    Label("back".localized, systemImage: "chevron.left")
                }
                Spacer()
            }
            .padding(.horizontal)

            Spacer()
            Image(systemName: "doc.text.fill")
                .font(.system(size: 64))
                .foregroundStyle(Color.accentColor)
            Text(String(format: "item_number".localized, viewModel.id)).font(.title.bold())
            Button("open_next".localized) { viewModel.openNext() }
                .buttonStyle(.borderedProminent)
            Button("back_to_top".localized) { viewModel.goToTop() }
                .buttonStyle(.bordered)
            Spacer()
        }
        .padding(.top, 8)
    }
}
