//
//  AppConfig.swift
//  AdmobSwitUI
//
//  Decode từ key Remote Config `app_configs` (tách khỏi `ad_config`).
//  Chứa các cờ vận hành app + cờ phát hiện "đang bị review".
//

import Foundation

struct AppConfig: Codable {

    var onlyShowLanguage: Bool = true
    var appVersion: String = ""
    var appToken: String = ""
    var eventToken: String = ""

    init() {}

    init(from decoder: Decoder) throws {
        let c = try decoder.container(keyedBy: CodingKeys.self)
        onlyShowLanguage = try c.decodeIfPresent(Bool.self, forKey: .onlyShowLanguage) ?? false
        appVersion = try c.decodeIfPresent(String.self, forKey: .appVersion) ?? ""
        appToken = try c.decodeIfPresent(String.self, forKey: .appToken) ?? ""
        eventToken = try c.decodeIfPresent(String.self, forKey: .eventToken) ?? ""
    }

    /// App có đang trong quá trình App Store review hay không.
    ///
    /// Mẹo: trên Remote Config đặt `appVersion` = version ĐÃ được duyệt/phát
    /// hành công khai. Build mới nộp lên review luôn có version KHÁC (cao hơn)
    /// → `appVersion != bundleVersion` → coi như đang review → tắt các ad dễ
    /// gây reject (interstitial dồn dập, app-open, full-screen native…).
    /// Khi build đó được duyệt và bạn cập nhật `appVersion` trên console cho
    /// khớp → cờ tự về false → ads chạy bình thường. Không cần update app.
    var isInReview: Bool {
        let bundleVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? ""
        return appVersion != bundleVersion
    }
}
