//
//  AppLanguage.swift
//  SwiftBase
//
//  Created by VanTuan on 18/6/26.
//

import Foundation

enum AppLanguage: String, CaseIterable, Identifiable {
    case english = "en"
    case vietnamese = "vi"
    case spanish = "es"
    case french = "fr"
    case german = "de"
    case japanese = "ja"

    var id: String { rawValue }

    /// Name shown in the user's own language.
    var displayName: String {
        switch self {
        case .english:    return "English"
        case .vietnamese: return "Tiếng Việt"
        case .spanish:    return "Español"
        case .french:     return "Français"
        case .german:     return "Deutsch"
        case .japanese:   return "日本語"
        }
    }

    /// Flag emoji used as a lightweight icon.
    var flag: String {
        switch self {
        case .english:    return "🇬🇧"
        case .vietnamese: return "🇻🇳"
        case .spanish:    return "🇪🇸"
        case .french:     return "🇫🇷"
        case .german:     return "🇩🇪"
        case .japanese:   return "🇯🇵"
        }
    }

    /// Best match for the device's current language, falling back to English.
    static var deviceDefault: AppLanguage {
        let code = Locale.current.language.languageCode?.identifier ?? "en"
        return AppLanguage(rawValue: code) ?? .english
    }
}
