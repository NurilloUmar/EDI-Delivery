import SwiftUI

/// Barcha bottom sheet'lar uchun umumiy sarlavha: chapda title, o'ngda dumaloq
/// yopish (✕) tugmasi. Standart paddinglar bilan — har sheet bir xil ko'rinadi.
struct BottomSheetHeader: View {
    let title: String
    let onClose: () -> Void

    var body: some View {
        HStack(alignment: .top) {
            Text(title)
                .font(.system(size: 18, weight: .semibold))
                .foregroundColor(.primary)
                .multilineTextAlignment(.leading)

            Spacer(minLength: 12)

            Button(action: onClose) {
                Image(systemName: "xmark")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.primary)
                    .frame(width: 32, height: 32)
                    .background(Color(.systemGray6))
                    .clipShape(Circle())
            }
        }
        .padding(.horizontal, 16)
        .padding(.top, 24)
        .padding(.bottom, 16)
    }
}

extension View {
    /// Barcha bottom sheet'lar uchun umumiy taqdimot uslubi: detentlar,
    /// tortish indikatori va 24pt burchak radiusi.
    func bottomSheetChrome(detents: Set<PresentationDetent> = [.medium, .large]) -> some View {
        self
            .presentationDetents(detents)
            .presentationDragIndicator(.visible)
            .presentationCornerRadius(24)
    }
}
