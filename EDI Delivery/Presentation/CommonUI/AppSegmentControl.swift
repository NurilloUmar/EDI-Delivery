import SwiftUI

/// Yagona segment control — Apple UISegmentedControl uslubida.
/// Konteyner kulrang (controlSurface), tanlangan oq pill, tanlanmaganlar
/// shaffof bo'lib konteyner orqali ko'rinadi.
/// `selectedColor` orqali har bir segment uchun rangni o'zgartirish mumkin.
struct AppSegmentControl: View {

    let titles: [String]
    @Binding var selectedIndex: Int
    var selectedColor: (Int) -> Color = { _ in AppColor.brand }
    var onChange: ((Int) -> Void)?

    var body: some View {
        HStack(spacing: 0) {
            ForEach(Array(titles.enumerated()), id: \.offset) { index, title in
                if index > 0 {
                    separator(after: index - 1)
                }
                segmentButton(title: title, index: index)
            }
        }
        .padding(AppMetric.segmentInnerPadding)
        .background(AppColor.controlSurface)
        .clipShape(RoundedRectangle(cornerRadius: AppMetric.radiusMD))
    }

    private func segmentButton(title: String, index: Int) -> some View {
        let isSelected = selectedIndex == index
        let color = selectedColor(index)

        return Button {
            guard selectedIndex != index else { return }
            withAnimation(.easeInOut(duration: 0.2)) {
                selectedIndex = index
            }
            onChange?(index)
        } label: {
            Text(title)
                .font(isSelected ? AppFont.bodySemibold : AppFont.body)
                .foregroundColor(isSelected ? color : Color.primary.opacity(0.75))
                .frame(maxWidth: .infinity)
                .frame(height: AppMetric.segmentHeight)
                .background(isSelected ? Color.white : Color.clear)
                .clipShape(RoundedRectangle(cornerRadius: AppMetric.radiusSM + 1))
                .overlay(
                    RoundedRectangle(cornerRadius: AppMetric.radiusSM + 1)
                        .stroke(
                            isSelected ? Color.black.opacity(0.04) : Color.clear,
                            lineWidth: 0.5
                        )
                )
                .shadow(
                    color: isSelected ? Color.black.opacity(0.12) : Color.clear,
                    radius: 3, x: 0, y: 1
                )
        }
    }

    /// Apple uslubidagi nozik vertikal ajratuvchi —
    /// faqat ikki qo'shni segment ham tanlanmagan bo'lsa ko'rsatiladi.
    @ViewBuilder
    private func separator(after index: Int) -> some View {
        let prevSelected = selectedIndex == index
        let nextSelected = selectedIndex == index + 1
        let show = !prevSelected && !nextSelected

        Rectangle()
            .fill(Color.gray.opacity(show ? 0.12 : 0))
            .frame(width: 0.5, height: 18)
            .animation(.easeInOut(duration: 0.15), value: selectedIndex)
    }
}
