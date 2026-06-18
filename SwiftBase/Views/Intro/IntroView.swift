//
//  IntroView.swift
//  SwiftBase
//
//  Created by VanTuan on 18/6/26.
//

import SwiftUI
import ads_swift

struct IntroView: View {
    @EnvironmentObject private var coordinator: AppFlowCoordinator
    @State private var index = 0

    private let pages = IntroPage.all
    private var isLast: Bool { index == pages.count - 1 }

    /// Page-conditional native ads: first page (`nativeIntro1`) and last page
    /// (`nativeIntro3`). The middle page intentionally has no ad.
    @State private var nativeIntro1VM: NativeAdViewModel?
    @State private var nativeIntro3VM: NativeAdViewModel?

    private var currentAdVM: NativeAdViewModel? {
        switch index {
        case 0:                 return nativeIntro1VM
        case pages.count - 1:   return nativeIntro3VM
        default:                return nil
        }
    }

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

            if let vm = currentAdVM {
                NativeContentView(nativeViewModel: vm, style: .nativeLargeMediaCtaBottom)
                    .padding(.horizontal)
            }

            primaryButton
        }
        .onAppear { loadAds() }
        .trackScreen(.intro)
    }

    /// Load both intro placements up front so they're ready as the user pages.
    private func loadAds() {
        let c1 = AdUtil.config.nativeIntro1
        if c1.isEnable, nativeIntro1VM == nil {
            let vm = NativeAdViewModel(adUnitID: c1.id)
            vm.refreshAd()
            nativeIntro1VM = vm
        }
        let c3 = AdUtil.config.nativeIntro3
        if c3.isEnable, nativeIntro3VM == nil {
            let vm = NativeAdViewModel(adUnitID: c3.id)
            vm.refreshAd()
            nativeIntro3VM = vm
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
