import SwiftUI

/// Butun ilova bo'yicha yagona typography.
enum AppFont {

    // MARK: - Display
    static let largeTitle = Font.system(size: 28, weight: .bold, design: .rounded)
    static let title = Font.system(size: 20, weight: .bold)
    static let title2 = Font.system(size: 18, weight: .semibold)

    // MARK: - Body
    static let headline = Font.system(size: 16, weight: .semibold)
    static let body = Font.system(size: 15)
    static let bodyMedium = Font.system(size: 15, weight: .medium)
    static let bodySemibold = Font.system(size: 15, weight: .semibold)

    // MARK: - Small
    static let callout = Font.system(size: 14)
    static let calloutMedium = Font.system(size: 14, weight: .medium)
    static let calloutSemibold = Font.system(size: 14, weight: .semibold)

    static let caption = Font.system(size: 13)
    static let captionMedium = Font.system(size: 13, weight: .medium)
    static let captionSmall = Font.system(size: 12)
    static let captionSmallMedium = Font.system(size: 12, weight: .medium)

    // MARK: - Numeric
    static let numericLarge = Font.system(size: 18, weight: .bold, design: .rounded)
    static let numericMedium = Font.system(size: 16, weight: .bold, design: .rounded)
}
