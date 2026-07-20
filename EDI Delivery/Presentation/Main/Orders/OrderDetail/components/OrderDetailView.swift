import SwiftUI

struct OrderDetailView: View {

    @ObservedObject var viewModel: OrderDetailViewModel
    @State private var searchText: String = ""

    private var filteredItems: [OrderLineItem] {
        guard let items = viewModel.item.detail?.items else { return [] }
        guard !searchText.isEmpty else { return items }
        return items.filter { ($0.productName ?? "").localizedCaseInsensitiveContains(searchText) }
    }

    var body: some View {
        Group {
            if let detail = viewModel.item.detail {
                VStack(spacing: 0) {
                    OrderDetailHeaderCard(detail: detail)
                        .padding(.horizontal, AppMetric.spacingLG)
                        .padding(.top, AppMetric.spacingMD)

                    ScrollView {
                        VStack(spacing: 0) {
                            ForEach(Array(filteredItems.enumerated()), id: \.element.id) { index, item in
                                OrderDetailItemRow(item: item, index: index)
                                    .background(index % 2 == 0 ? Color(.systemGray6).opacity(0.6) : Color.clear)
                            }
                            OrderDetailTotalCard(detail: detail)
                                .padding(.horizontal, AppMetric.spacingLG)
                                .padding(.top, AppMetric.spacingMD)

                            actionsView(for: detail)
                        }
                    }
                }
            } else {
                Color.clear
            }
        }
        .background(AppColor.background.ignoresSafeArea())
 
    }

    @ViewBuilder
    private func actionsView(for detail: OrderDetailResponse) -> some View {
        let status = detail.status.flatMap { OrderStatus(rawValue: $0) }
        if status != .documentCreated {
            VStack(spacing: AppMetric.spacingMD) {
                PrimaryButton(title: L(.startSale)) {
                    viewModel.handleEvent(eventType: .didTapStartSelling)
                }
                .disabled(status == .temporaryCanceled)
                .opacity(status == .temporaryCanceled ? 0.5 : 1)

            }
            .padding(.horizontal, AppMetric.spacingLG)
            .padding(.top, AppMetric.spacingLG)
            .padding(.bottom, AppMetric.spacingXL)
        }
    }
}

// MARK: - Header Card

private struct OrderDetailHeaderCard: View {
    let detail: OrderDetailResponse

    private var status: OrderStatus? {
        guard let s = detail.status else { return nil }
        return OrderStatus(rawValue: s)
    }

    private var formattedDate: String {
        guard let dateStr = detail.date else { return "" }
        let input = DateFormatter()
        input.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let output = DateFormatter()
        output.dateFormat = "dd.MM.yyyy"
        return input.date(from: dateStr).map { output.string(from: $0) } ?? dateStr
    }

    var body: some View {
        VStack(alignment: .leading, spacing: AppMetric.spacingSM) {
            HStack(alignment: .top) {
                Text(detail.clientBranch?.name ?? "")
                    .font(AppFont.headline)
                    .foregroundColor(.primary)
                    .lineLimit(2)
                Spacer()
                if let status {
                    Text(status.title)
                        .font(AppFont.captionSmallMedium)
                        .foregroundColor(status.color)
                        .padding(.horizontal, AppMetric.badgePaddingH)
                        .padding(.vertical, AppMetric.badgePaddingV)
                        .background(status.color.opacity(0.15))
                        .overlay(
                            RoundedRectangle(cornerRadius: AppMetric.badgeRadius)
                                .stroke(status.color, lineWidth: 1)
                        )
                        .clipShape(RoundedRectangle(cornerRadius: AppMetric.badgeRadius))
                }
            }
            
            HStack(spacing: 6) {
                Text(detail.number ?? "")
                    .font(AppFont.caption)
                    .foregroundColor(.secondary)
                Image(systemName: "circle.fill")
                    .font(.system(size: 3))
                    .foregroundColor(.secondary)
                Text(formattedDate)
                    .font(AppFont.caption)
                    .foregroundColor(.secondary)
            }
            
            if let clientName = detail.client?.name {
                Divider()
                InfoRow(label: L(.client), value: clientName)
            }
        }
        .padding(AppMetric.cardPadding)
        .background(Color(.systemBackground))
        .clipShape(RoundedRectangle(cornerRadius: AppMetric.cardRadius))
    }
}

// MARK: - Item Row (Android-style)

private struct OrderDetailItemRow: View {
    let item: OrderLineItem
    let index: Int

    private var displayIndex: String {
        let n = index + 1
        return n < 10 ? "0\(n)." : "\(n)."
    }

    private var qty: String {
        guard let q = item.quantity else { return "0" }
        return q.truncatingRemainder(dividingBy: 1) == 0
            ? String(Int(q))
            : String(format: "%.2f", q)
    }

    var body: some View {
        HStack(alignment: .top, spacing: 4) {
            Text(displayIndex)
                .font(.system(size: 16, weight: .medium))
                .foregroundColor(.primary.opacity(0.5))

            Text(item.productName ?? "")
                .font(.system(size: 17, weight: .medium))
                .foregroundColor(.primary)
                .frame(maxWidth: .infinity, alignment: .leading)
                .fixedSize(horizontal: false, vertical: true)

            VStack(alignment: .trailing, spacing: 2) {
                HStack(spacing: 2) {
                    Text(qty)
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(.primary)
                    Text(L(.unitPiece))
                        .font(.system(size: 14))
                        .foregroundColor(.primary.opacity(0.5))
                }
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 10)
    }
}

// MARK: - Total Card

private struct OrderDetailTotalCard: View {
    let detail: OrderDetailResponse

    var body: some View {
        HStack {
            Text(L(.totalAmount))
                .font(AppFont.bodyMedium)
                .foregroundColor(.secondary)
            Spacer()
            Text(formatAmount(detail.extraInfo?.totalWithVat ?? 0))
                .font(AppFont.title2)
                .foregroundColor(AppColor.brand)
        }
        .padding(AppMetric.cardPadding)
        .background(Color(.systemBackground))
        .clipShape(RoundedRectangle(cornerRadius: AppMetric.cardRadius))
    }
}

// MARK: - Shared InfoRow

struct InfoRow: View {
    let label: String
    let value: String

    var body: some View {
        HStack(alignment: .top, spacing: 4) {

            Text(label)
                .font(AppFont.callout)
                .foregroundColor(.secondary)
                .fixedSize()

            Text(value)
                .font(AppFont.calloutMedium)
                .foregroundColor(.primary)
                .multilineTextAlignment(.leading)

            Spacer(minLength: 0)
        }
    }
}
