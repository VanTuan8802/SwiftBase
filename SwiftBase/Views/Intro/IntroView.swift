//
//  IntroView.swift
//  SwiftBase
//
//  Created by VanTuan on 18/6/26.
//

import SwiftUI

struct IntroView: View {
    @EnvironmentObject private var coordinator: AppFlowCoordinator
    @State private var index = 0

    private let pages = IntroPage.all
    private var isLast: Bool { index == pages.count - 1 }

    var body: some View {
        VStack(spacing: 0) {
            skipBar

            TabView(selection: $index) {
                ForEach(Array(pages.enumerated()), id: \.element.id) { offset, page in
                    pageView(page)
                        .tag(offset)
                }
            }
            .tabViewStyle(.page(indexDisplayMode: .always))
            .indexViewStyle(.page(backgroundDisplayMode: .always))

            primaryButton
        }
    }

    private var skipBar: some View {
        HStack {
            Spacer()
            Button("skip".localized) { coordinator.finishOnboarding() }
                .font(.subheadline.weight(.medium))
                .foregroundStyle(.secondary)
                .opacity(isLast ? 0 : 1)
                .disabled(isLast)
        }
        .padding(.horizontal)
        .padding(.top, 12)
    }

    private func pageView(_ page: IntroPage) -> some View {
        VStack(spacing: 24) {
            Spacer()
            Image(systemName: page.systemImage)
                .font(.system(size: 96, weight: .bold))
                .foregroundStyle(page.tint)
            VStack(spacing: 12) {
                Text(page.title.localized)
                    .font(.title.bold())
                    .multilineTextAlignment(.center)
                Text(page.message.localized)
                    .font(.body)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
            }
            .padding(.horizontal, 32)
            Spacer()
            Spacer()
        }
    }

    private var primaryButton: some View {
        PrimaryButton(isLast ? "get_started" : "next") {
            if isLast {
                coordinator.finishOnboarding()
            } else {
                withAnimation { index += 1 }
            }
        }
        .padding()
    }
}

#if DEBUG
#Preview {
    IntroView()
        .environmentObject(AppFlowCoordinator())
}
#endif
