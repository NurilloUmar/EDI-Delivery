import SwiftUI

struct DocumentDetailView: View {
    @ObservedObject var viewModel: DocumentDetailViewModel

    var body: some View {
        Group {
            if let doc = viewModel.item.document {
                ScrollView {
                    VStack(spacing: AppMetric.spacingMD) {
                        DocumentDetailHeaderCard(doc: doc)
                        if let items = doc.items, !items.isEmpty {
                            DocumentDetailItemsSection(items: items)
                        }
                        DocumentDetailTotalCard(doc: doc)
                    }
                    .padding(.horizontal, AppMetric.spacingLG)
                    .padding(.vertical, AppMetric.spacingMD)
                }
            } else {
                Color.clear
            }
        }
        .background(AppColor.background.ignoresSafeArea())
    }
}

// MARK: - Header Card

private struct DocumentDetailHeaderCard: View {
    let doc: DocumentResponse

    private var formattedDate: String {
        guard let dateStr = doc.date else { return "" }
        let input = DateFormatter()
        input.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let output = DateFormatter()
        output.dateFormat = "dd.MM.yyyy"
        return input.date(from: dateStr).map { output.string(from: $0) } ?? dateStr
    }

    var body: some View {
        VStack(alignment: .leading, spacing: AppMetric.spacingSM) {
            HStack {
                Text(doc.number ?? "")
                    .font(AppFont.headline)
                    .foregroundColor(.primary)
                Spacer()
                Text(formattedDate)
                    .font(AppFont.caption)
                    .foregroundColor(.secondary)
            }
            Divider()
            InfoRow(label: L(.branch), value: doc.clientBranch?.name ?? "—")
            if let contract = doc.contractNumber {
                InfoRow(label: L(.contract), value: contract)
            }
        }
        .padding(AppMetric.cardPadding)
        .background(Color(.systemBackground))
        .clipShape(RoundedRectangle(cornerRadius: AppMetric.cardRadius))
    }
}

// MARK: - Items Section

private struct DocumentDetailItemsSection: View {
    let items: [DocumentItemResponse]

    var body: some View {
        VStack(alignment: .leading, spacing: AppMetric.spacingSM) {
            Text(L(.products))
                .font(AppFont.title2)
                .foregroundColor(.primary)

            VStack(spacing: 1) {
                ForEach(Array(items.enumerated()), id: \.element.id) { index, item in
                    DocumentDetailItemRow(item: item, number: index + 1)
                }
            }
            .clipShape(RoundedRectangle(cornerRadius: AppMetric.cardRadius))
        }
    }
}

private struct DocumentDetailItemRow: View {
    let item: DocumentItemResponse
    let number: Int

    private var qty: String {
        guard let q = item.quantity else { return "0" }
        return q.truncatingRemainder(dividingBy: 1) == 0 ? String(Int(q)) : String(format: "%.2f", q)
    }

    var body: some View {
        HStack(spacing: AppMetric.spacingMD) {
            Text(String(format: "%02d", number))
                .font(AppFont.captionMedium)
                .foregroundColor(AppColor.brand)
                .frame(minWidth: 16, alignment: .leading)

            VStack(alignment: .leading, spacing: AppMetric.spacingXS) {
                Text(item.productName ?? "—")
                    .font(AppFont.bodyMedium)
                    .foregroundColor(.primary)
                Text("\(Loc.quantity(qty)) · \(item.measurement ?? "")")
                    .font(AppFont.caption)
                    .foregroundColor(.secondary)
            }

            Spacer()

            VStack(alignment: .trailing, spacing: AppMetric.spacingXS) {
                Text(formatAmount(item.priceWithVat))
                    .font(AppFont.captionMedium)
                    .foregroundColor(.secondary)
                Text(formatAmount(item.totalWithVat ?? item.totalPrice ?? 0))
                    .font(AppFont.captionMedium)
                    .foregroundColor(AppColor.brand)
            }
        }
        .padding(AppMetric.cardPadding)
        .background(Color(.systemBackground))
    }
}

// MARK: - Total Card

private struct DocumentDetailTotalCard: View {
    let doc: DocumentResponse

    var body: some View {
        VStack(spacing: AppMetric.spacingSM) {
            HStack {
                Text(L(.totalAmount))
                    .font(AppFont.bodyMedium)
                    .foregroundColor(.secondary)
                Spacer()
                Text(formatAmount(doc.totalWithVat ?? doc.totalPrice ?? 0))
                    .font(AppFont.numericMedium)
                    .foregroundColor(AppColor.brand)
            }
            if let vat = doc.totalVat, vat > 0 {
                HStack {
                    Text(L(.vat))
                        .font(AppFont.caption)
                        .foregroundColor(.secondary)
                    Spacer()
                    Text(formatAmount(vat))
                        .font(AppFont.captionMedium)
                        .foregroundColor(.secondary)
                }
            }
        }
        .padding(AppMetric.cardPadding)
        .background(Color(.systemBackground))
        .clipShape(RoundedRectangle(cornerRadius: AppMetric.cardRadius))
    }
}
