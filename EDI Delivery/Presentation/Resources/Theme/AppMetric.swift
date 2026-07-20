internal import Foundation
import CoreGraphics

/// Butun ilova bo'yicha yagona spacing va sizing qiymatlari.
enum AppMetric {

    // MARK: - Spacing (asosiy padding va spacing'lar)
    static let spacingXS: CGFloat = 4
    static let spacingSM: CGFloat = 8
    static let spacingMD: CGFloat = 12
    static let spacingLG: CGFloat = 16
    static let spacingXL: CGFloat = 24
    static let spacingXXL: CGFloat = 32

    // MARK: - Corner radius
    static let radiusSM: CGFloat = 10
    static let radiusMD: CGFloat = 14
    static let radiusLG: CGFloat = 18
    static let radiusPill: CGFloat = 22

    // MARK: - Card
    static let cardPadding: CGFloat = 16
    static let cardRadius: CGFloat = 18
    static let cardStrokeWidth: CGFloat = 0.5

    // MARK: - Input / Segment
    static let controlHeight: CGFloat = 48
    static let segmentHeight: CGFloat = 42
    static let segmentInnerPadding: CGFloat = 4

    // MARK: - Filter chip
    static let chipPaddingH: CGFloat = 18
    static let chipPaddingV: CGFloat = 10
    static let chipRadius: CGFloat = 22

    // MARK: - Status badge
    static let badgePaddingH: CGFloat = 12
    static let badgePaddingV: CGFloat = 6
    static let badgeRadius: CGFloat = 20
    static let badgeDotSize: CGFloat = 6
}
