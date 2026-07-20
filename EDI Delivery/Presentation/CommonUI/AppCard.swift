import SwiftUI

/// Butun ilova bo'yicha yagona karta o'rami (oq fon + radius + nozik chiziq).
struct AppCard<Content: View>: View {

    private let content: Content
    private let padding: CGFloat
    private let radius: CGFloat
    private let background: Color

    init(
        padding: CGFloat = AppMetric.cardPadding,
        radius: CGFloat = AppMetric.cardRadius,
        background: Color = .white,
        @ViewBuilder content: () -> Content
    ) {
        self.padding = padding
        self.radius = radius
        self.background = background
        self.content = content()
    }

    var body: some View {
        content
            .padding(padding)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(background)
            .clipShape(RoundedRectangle(cornerRadius: radius))
            .overlay(
                RoundedRectangle(cornerRadius: radius)
                    .stroke(AppColor.separator.opacity(0.6), lineWidth: AppMetric.cardStrokeWidth)
            )
    }
}
