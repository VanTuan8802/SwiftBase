import Foundation
import SwiftUI
import FirebaseAnalytics

// MARK: - Log screen_view (callable outside SwiftUI)
//
// COPY NGUYÊN file này — app-agnostic, không cần sửa.
// Chỉ cần định nghĩa `AnalyticsScreen` (xem AnalyticsScreen.swift) là dùng được.

enum AnalyticsTracker {
    static func logScreenView(_ screen: AnalyticsScreen) {
        let name = sanitizeScreenName(screen.rawValue)
        #if DEBUG
        print("[Analytics] screen_view: \(name)")
        #endif
        Analytics.logEvent(AnalyticsEventScreenView, parameters: [
            AnalyticsParameterScreenName: name,
            AnalyticsParameterScreenClass: name
        ])
    }

    /// Cắt phần generic Swift type name (`UIHostingController<...>`) và giới hạn
    /// 100 ký tự theo quy định của Firebase `screen_name`.
    static func sanitizeScreenName(_ name: String) -> String {
        var cleaned = name
        if let start = cleaned.firstIndex(of: "<") {
            cleaned = String(cleaned[..<start])
        }
        if cleaned.count > 100 {
            cleaned = String(cleaned.prefix(100))
        }
        return cleaned
    }
}

// MARK: - ViewModifier

struct ScreenTrackingModifier: ViewModifier {
    let screen: AnalyticsScreen

    func body(content: Content) -> some View {
        content
            .onAppear {
                AnalyticsTracker.logScreenView(screen)
            }
    }
}

// MARK: - View extension

extension View {
    func trackScreen(_ screen: AnalyticsScreen) -> some View {
        modifier(ScreenTrackingModifier(screen: screen))
    }
}
