// //
// //  CustomAppOpenAdManager.swift
// //  AdmobSwitUI
// //
// //  Created by Đức Mạnh on 10/03/2026.
// //

// import Foundation
// import ads_swift
// import UIKit

// class CustomAdsOpenManager {

//     static let shared = CustomAdsOpenManager()
//     private var showCount = 0
//     private var shouldShow = true
//     private var isExcludeScreen = false
    
//     private var appOpenAdId: String?
//     private var interAdId: String?
//     private var timer: Timer?
//     private(set) var timeLimit: TimeInterval = 0
//     private var shouldShowInter = true
    
//     private var lastShownTime: TimeInterval = 0
//     private let minIntervalBetweenShows: TimeInterval = 1.0
//     private var wasInBackground = false

//     func initialize() {
//         listenToAppStateChanges()
//         AdUtil.preloadOpenRecent()
//     }

//     func setShouldShow(_ value: Bool) {
//         shouldShow = value
//     }

//     func setIsExcludeScreen(_ value: Bool) {
//         isExcludeScreen = value
//     }

//     deinit {
//         NotificationCenter.default.removeObserver(self)
//     }

//     private func listenToAppStateChanges() {
//         NotificationCenter.default.addObserver(
//             self,
//             selector: #selector(handleAppStateChange),
//             name: UIApplication.didBecomeActiveNotification,
//             object: nil
//         )
        
//         NotificationCenter.default.addObserver(
//                 self,
//                 selector: #selector(handleDidEnterBackground),
//                 name: UIApplication.didEnterBackgroundNotification,
//                 object: nil
//             )
            
//             NotificationCenter.default.addObserver(
//                 self,
//                 selector: #selector(handleWillResignActive),
//                 name: UIApplication.willResignActiveNotification,
//                 object: nil
//             )
//     }

//     @objc private func handleWillResignActive() {
//         wasInBackground = false
//     }

//     @objc private func handleDidEnterBackground() {
//         wasInBackground = true
//     }
    
//     @objc private func handleAppStateChange() {
//         guard wasInBackground else {
//             print("App active lại nhưng không phải từ background — skip ad")
//             return
//         }
//         wasInBackground = false

//         let now = Date().timeIntervalSince1970
//         if now - lastShownTime < minIntervalBetweenShows {
//             return
//         }
//         lastShownTime = now

//         guard shouldShow,
//               !isExcludeScreen,
//               !AdsManager.shared.isFullscreenAdShowing else {
//             return
//         }

//         if (isExcludeScreen) {
//             isExcludeScreen = false
//             return
//         }

//         showCount += 1
//         print("🔄 Custom Manager: App became active (count: \(showCount))")
        
//         if timeLimit > 0 {
//             shouldShowInter = false
//         }
        
//         if showCount <= 3 {
//             print("Hiển thị App Open Ad (lần \(showCount))")
//             AdUtil.showOpenRecent()
//         }
//         else {
//             guard shouldShowInter else {
//                 return
//             }
            
//             print("Hiển thị Interstitial Ad (lần \(showCount))")
//             AdUtil.showInterAll(.interRecent)
//         }
//     }
// }
