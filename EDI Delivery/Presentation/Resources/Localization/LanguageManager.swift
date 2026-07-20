internal import Foundation
internal import Combine

enum AppLanguage: String, CaseIterable, Identifiable {
    case uz
    case ru
    case en

    var id: String { rawValue }

    var title: String {
        switch self {
        case .uz: return "O'zbekcha"
        case .ru: return "Русский"
        case .en: return "English"
        }
    }

    var nativeName: String {
        switch self {
        case .uz: return "O'zbekcha"
        case .ru: return "Русский"
        case .en: return "English"
        }
    }

    var flag: String {
        switch self {
        case .uz: return "🇺🇿"
        case .ru: return "🇷🇺"
        case .en: return "🇬🇧"
        }
    }
}

final class LanguageManager: ObservableObject {

    static let shared = LanguageManager()

    private static let storageKey = "app_language"

    @Published private(set) var current: AppLanguage

    private init() {
        let raw = UserDefaults.standard.string(forKey: Self.storageKey) ?? AppLanguage.uz.rawValue
        self.current = AppLanguage(rawValue: raw) ?? .uz
    }

    func set(_ lang: AppLanguage) {
        guard current != lang else { return }
        current = lang
        UserDefaults.standard.set(lang.rawValue, forKey: Self.storageKey)
        NotificationCenter.default.post(name: .appLanguageDidChange, object: lang)
    }

    func t(_ key: LocalizedKey) -> String {
        Localizations.dictionary[current]?[key]
            ?? Localizations.dictionary[.uz]?[key]
            ?? key.rawValue
    }

    subscript(key: LocalizedKey) -> String {
        t(key)
    }
}

extension Notification.Name {
    static let appLanguageDidChange = Notification.Name("appLanguageDidChange")
}
