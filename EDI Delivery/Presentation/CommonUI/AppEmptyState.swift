import SwiftUI

/// Yagona bo'sh holat ko'rinishi: katta SF Symbol + matn.
struct AppEmptyState: View {

    let icon: String
    let title: String
    var iconColor: Color = Color.gray.opacity(0.5)

    var body: some View {
        VStack(spacing: AppMetric.spacingMD) {
            Image(systemName: icon)
                .font(.system(size: 44))
                .foregroundColor(iconColor)
            Text(title)
                .font(AppFont.headline)
                .foregroundColor(.gray)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
        .padding(.top, 60)
    }
}
