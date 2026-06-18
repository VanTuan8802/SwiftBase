//
//  HomeDetailScreen.swift
//  SwiftBase
//
//  Created by VanTuan on 18/6/26.
//

import SwiftUI


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
        .trackScreen(.homeDetail)
    }
}
