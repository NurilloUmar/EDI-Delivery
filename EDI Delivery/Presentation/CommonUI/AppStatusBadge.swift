import SwiftUI

/// Yagona status badge: rangli nuqta + matn, pill shaklida.
struct AppStatusBadge: View {

    let text: String
    let color: Color
    var background: Color?

    var body: some View {
        HStack(spacing: AppMetric.spacingSM - 2) {
            Circle()
                .fill(color)
                .frame(width: AppMetric.badgeDotSize, height: AppMetric.badgeDotSize)
            Text(text)
                .font(AppFont.captionSmall)
                .foregroundColor(color)
                .lineLimit(1)
        }
        .padding(.horizontal, AppMetric.badgePaddingH)
        .padding(.vertical, AppMetric.badgePaddingV)
        .background(background ?? color.opacity(0.12))
        .clipShape(RoundedRectangle(cornerRadius: AppMetric.badgeRadius))
    }
}
