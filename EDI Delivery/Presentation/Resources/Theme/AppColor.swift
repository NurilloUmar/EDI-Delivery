import SwiftUI
import UIKit

// MARK: - SwiftUI Palette

enum AppColor {

    // MARK: Brand
    /// Asosiy ko'k — login tugmasi, accent
    static let brand = Color(hex: "#2B7FFF")
    /// Yumshoq ko'k — payment ikona aksenti
    static let brandSecondary = Color(hex: "#5B8DEF")
    /// Brand fon (icon chip ortidagi och ko'k)
    static let brandTint = Color(hex: "#EEF3FD")

    // MARK: Background / Surface
    /// Asosiy scroll fon
    static let background = Color(hex: "#F2F2F7")
    /// Off-white sirt (Profile bg)
    static let surface = Color(hex: "#FAFAFA")
    /// Och kulrang surface (legacy BACK_COLOR)
    static let surfaceMuted = Color(hex: "#F3F4F7")
    /// Segmented control / control container foni (Apple UISegmentedControl uslubi)
    static let controlSurface = Color(hex: "#E5E5EA")
    /// Ajratuvchi / divider
    static let separator = Color(hex: "#E5E5EA")
    /// ID chip foni (legacy ID_BACK_COLOR)
    static let idChip = Color(hex: "#D2D8E6")

    // MARK: Semantic — Success (yashil)
    static let success = Color(hex: "#1D9E75")
    static let successStrong = Color(hex: "#3B6D11")
    static let successDeep = Color(hex: "#0F6E56")
    static let successTint = Color(hex: "#EAF3DE")
    static let successSoft = Color(hex: "#E1F5EE")
    static let successMint = Color(hex: "#CCF1D4")

    // MARK: Semantic — Warning (sariq / to'q sariq)
    static let warning = Color(hex: "#D97706")
    static let warningStrong = Color(hex: "#FF9500")
    static let warningTint = Color(hex: "#FEF3C7")
    static let warningSoft = Color(hex: "#FFF3E8")

    // MARK: Semantic — Danger (qizil)
    static let danger = Color(hex: "#DC2626")
    static let dangerStrong = Color(hex: "#E24B4A")
    static let dangerDeep = Color(hex: "#A32D2D")
    static let dangerTint = Color(hex: "#FEE2E2")
    static let dangerSoft = Color(hex: "#FCEBEB")

    // MARK: Document Types (dashboard)
    static let docInvoice = Color(hex: "#2563EB")
    static let docContract = Color(hex: "#1E1B4B")
    static let docAct = Color(hex: "#7C3AED")
    static let docOther = Color(hex: "#9CA3AF")

    // MARK: Contact Channels
    static let channelTelegram = Color(hex: "#2C87E9")
}

// MARK: - UIColor Mirror (UIKit uchun)

extension UIColor {

    convenience init(hex: String) {
        let trimmed = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: trimmed).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch trimmed.count {
        case 3:
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6:
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8:
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(
            red: CGFloat(r) / 255,
            green: CGFloat(g) / 255,
            blue: CGFloat(b) / 255,
            alpha: CGFloat(a) / 255
        )
    }

    // MARK: Brand
    static let appBrand = UIColor(hex: "#2B7FFF")

    // MARK: Background
    static let appBackground = UIColor(hex: "#F2F2F7")
    static let appSurfaceMuted = UIColor(hex: "#F3F4F7")
    static let appSeparator = UIColor(hex: "#E5E5EA")
    static let appIDChip = UIColor(hex: "#D2D8E6")

    // MARK: Alert semantic
    /// Yashil — alert success
    static let appSuccess = UIColor(hex: "#00CA00")
    /// Sariq — alert warning
    static let appWarning = UIColor(hex: "#F3B022")
    /// Qizil — alert error
    static let appDanger = UIColor(hex: "#EC3C1A")
    /// Ko'k — alert progress / info (brand bilan unified)
    static let appInfo = UIColor(hex: "#2B7FFF")
    /// Kulrang — alert unknown / disabled
    static let appNeutral = UIColor(hex: "#999999")
}
