import SwiftUI

/// Yagona filter chip — Documents/Partners status filterlari uchun.
struct AppFilterChip: View {

    let title: String
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(title)
                .font(AppFont.calloutMedium)
                .padding(.horizontal, AppMetric.chipPaddingH)
                .padding(.vertical, AppMetric.chipPaddingV)
                .background(isSelected ? AppColor.brand : AppColor.surfaceMuted)
                .foregroundColor(isSelected ? .white : .primary)
                .clipShape(RoundedRectangle(cornerRadius: AppMetric.chipRadius))
        }
    }
}

/// Gorizontal scroll'lab filter chip'lar ro'yxati.
struct AppFilterChipRow<Item: Hashable>: View {

    let items: [Item]
    let title: (Item) -> String
    @Binding var selected: Item
    var onChange: ((Item) -> Void)?

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: AppMetric.spacingSM) {
                ForEach(items, id: \.self) { item in
                    AppFilterChip(
                        title: title(item),
                        isSelected: selected == item
                    ) {
                        selected = item
                        onChange?(item)
                    }
                }
            }
            .padding(.vertical, AppMetric.spacingXS)
        }
    }
}
