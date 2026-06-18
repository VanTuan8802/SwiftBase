//
//  SplashView.swift
//  SwiftBase
//
//  Created by VanTuan on 18/6/26.
//

import SwiftUI
import ads_swift
import GoogleMobileAds
import AppTrackingTransparency

struct SplashView: View {
    @EnvironmentObject private var coordinator: AppFlowCoordinator
    @Environment(\.colorScheme) private var colorScheme
    @State private var appeared = false
    @State private var didStart = false

    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "square.stack.3d.up.fill")
                .font(.system(size: 72, weight: .bold))
                .foregroundStyle(Color.accentColor)
                .scaleEffect(appeared ? 1 : 0.7)
                .opacity(appeared ? 1 : 0)

            Text("SwiftBase")
                .font(.largeTitle.bold())
                .opacity(appeared ? 1 : 0)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(.systemBackground))
        .onAppear {
            withAnimation(.spring(response: 0.6, dampingFraction: 0.7)) {
                appeared = true
            }
        }
        .task {
            // Guard so the init sequence runs once even if `.task` re-fires.
            guard !didStart else { return }
            didStart = true
            await configAds()
        }
        .trackScreen(.splash)
    }
}

// MARK: - Ad initialization sequence
//
// The ORDER here is load-bearing — get it wrong and ads silently fail:
//   1. RemoteConfig.fetchAndActivate  (must finish first, or unit IDs are empty)
//   2. AdsManager.initialize          (now it has the IDs + interval)
//   3. Adjust + test devices
//   4. UMP / ATT consent              (before any app-open is initialized)
//   5. inter_splash                   (blocks until dismissed)
//   6. initAppOpenAd                  (after inter_splash, so they don't fight)
//   7. setShouldShow(true)            (un-mute app-open) → advance the flow
private extension SplashView {

    func configAds() async {
        // 1. Remote Config — resolves ad unit IDs + review flags.
        await withCheckedContinuation { (cont: CheckedContinuation<Void, Never>) in
            RemoteConfigManager.shared.fetchAndActivate { cont.resume() }
        }

        // 2. Ads SDK — only now do unit IDs exist.
        AdsManager.shared.initialize(
            intervalShowInter: RemoteConfigManager.shared.adConfig.intervalShowInter,
            nativeAdColorConfig: Self.nativeAdColorConfig(for: colorScheme)
        )

        // 3. Attribution + (debug) test devices so we never serve live ads in dev.
        AdjustManager.shared.initialize()
        #if DEBUG
        setTestDeviceIdentifiers()
        #endif

        // 4. Consent — request before app-open is wired so no ad obscures the popup.
        await requestConsent()

        // 5. Splash interstitial — wait until it's dismissed before continuing.
        await showInterSplash()

        // 6. App-open on resume — init AFTER inter_splash. `autoEnable: false` keeps
        //    it muted until we explicitly un-mute below.
        let appOpen = AdUtil.config.appopenResume
        if appOpen.isEnable {
            AdsManager.shared.initAppOpenAd(
                appOpenAdUnitId: appOpen.id,
                opacity: appOpen.opacity,
                autoEnable: false
            )
        }

        // 7. Un-mute, preload the home interstitial, advance the launch flow.
        AdsManager.shared.appLifecycleReactor?.setShouldShow(true)
        InterHomeUtil.instance.preload()
        coordinator.splashDidFinish()
    }

    /// ATT (Apple) then UMP (Google EU consent form). App-open is excluded while
    /// the prompts are on screen (no-op here since it isn't initialized yet, but
    /// kept for correctness if init order ever changes).
    func requestConsent() async {
        AdsManager.shared.appLifecycleReactor?.setIsExcludeScreen(true)
        await withCheckedContinuation { (cont: CheckedContinuation<Void, Never>) in
            ATTrackingManager.requestTrackingAuthorization { _ in cont.resume() }
        }
        await UMPManager.shared.requestConsentIfNeeded()
        AdsManager.shared.appLifecycleReactor?.setIsExcludeScreen(false)
    }

    func showInterSplash() async {
        await withCheckedContinuation { (cont: CheckedContinuation<Void, Never>) in
            AdUtil.showInter(config: AdUtil.config.interSplash) { cont.resume() }
        }
    }

    func setTestDeviceIdentifiers() {
        // Simulators receive Google test ads automatically. To test on a real
        // device, copy the hash from the Xcode console line "To get test ads on
        // this device, set: ...testDeviceIdentifiers = @[ \"<hash>\" ]" into here.
        MobileAds.shared.requestConfiguration.testDeviceIdentifiers = []
    }

    /// Adaptive light/dark native-ad chrome built from UIKit dynamic colors.
    static func nativeAdColorConfig(for scheme: ColorScheme) -> NativeAdColorConfig {
        let adBadge: UIColor = scheme == .dark ? .tertiaryLabel : .secondaryLabel
        return NativeAdColorConfig(
            headlineColor: Color(uiColor: .label),
            bodyColor: Color(uiColor: .secondaryLabel),
            adColor: Color(uiColor: adBadge),
            adBackgroundColor: Color(uiColor: .secondarySystemGroupedBackground),
            callToActionBackgroundColor: .accentColor,
            callToActionTextColor: .white,
            backgroundColor: Color(uiColor: .systemBackground)
        )
    }
}

#if DEBUG
#Preview {
    SplashView()
        .environmentObject(AppFlowCoordinator())
}
#endif
