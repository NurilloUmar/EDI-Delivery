import SwiftUI

struct BasketView: View {
    @ObservedObject var viewModel: BasketViewModel

    /// Naqd/Terminal summasini tahrirlash dialogi (Android `SalesPaymentChangeModal`).
    private enum PaymentField { case cash, card }
    @State private var editingPayment: PaymentField? = nil
    @State private var paymentDraft: String = ""
    @State private var lastValidPaymentDraft: String = ""

    var body: some View {
        Group {
            if let basket = viewModel.item.basket {
                ScrollView {
                    VStack(spacing: 0) {
                        if basket.branch != nil {
                            clientHeaderView(basket: basket)
                        } else {
                            emptyActionCard(icon: "exclamationmark.triangle.fill", text: L(.salePointNotSelected)) {
                                viewModel.handleEvent(eventType: .didTapAddSalePoint)
                            }
                            .padding(.horizontal, AppMetric.spacingLG)
                            .padding(.top, AppMetric.spacingMD)
                        }

                        if let items = basket.items, !items.isEmpty {
                            VStack(spacing: 0) {
                                ForEach(Array(items.enumerated()), id: \.element.id) { index, item in
                              
                                    let isEditable = basket.delivery_order_id == nil || item.has_marking != true
                                    HStack(spacing: 0) {
                                        SalesItemRow(item: item, index: index)
                                        Image(systemName: "chevron.right")
                                            .font(.system(size: 13, weight: .semibold))
                                            .foregroundColor(.secondary)
                                            .padding(.trailing, AppMetric.spacingLG)
                                    }
                                    .background(index % 2 == 0 ? Color(.systemGray6).opacity(0.6) : Color.clear)
                                    .contentShape(Rectangle())
                                    .onTapGesture {
                                        if isEditable {
                                            viewModel.handleEvent(eventType: .didTapItem(item))
                                        } else {
                                            viewModel.handleEvent(eventType: .didTapViewItem(item))
                                        }
                                    }
                                }
                            }
                            .padding(.top, AppMetric.spacingSM)

                            totalSection(basket: basket)

                            if basket.closingType != 1 {
                                paymentSection(basket: basket)
                            }

                            PrimaryButton(title: L(.submit)) {
                                viewModel.handleEvent(eventType: .approve)
                            }
                            .padding(.horizontal, 2)
                            .padding(.top, AppMetric.spacingMD)
                            .padding(.bottom, AppMetric.spacingXL)
                        } else {
                            emptyActionCard(icon: "shippingbox", text: L(.tapToAddProduct)) {
                                viewModel.handleEvent(eventType: .didTapAddProduct)
                            }
                            .padding(.horizontal, AppMetric.spacingLG)
                            .padding(.top, AppMetric.spacingLG)
                        }
                    }
                }
                .sheet(
                    isPresented: Binding(
                        get: { viewModel.item.editingItem != nil },
                        set: { if !$0 { viewModel.handleEvent(eventType: .dismissEdit) } }
                    )
                ) {
                    if let editing = viewModel.item.editingItem {
                        BasketEditItemSheet(
                            item: editing,
                            isPriceEditable: viewModel.item.basket?.delivery_order_id == nil,
                            isSubmitting: viewModel.item.isUpdatingItem,
                            onDismiss: { viewModel.handleEvent(eventType: .dismissEdit) },
                            onConfirm: { price, units in
                                viewModel.handleEvent(
                                    eventType: .confirmEdit(
                                        itemId: editing.id ?? "",
                                        price: price,
                                        units: units
                                    )
                                )
                            }
                        )
                    }
                }
                .sheet(
                    isPresented: Binding(
                        get: { viewModel.item.detailItem != nil },
                        set: { if !$0 { viewModel.handleEvent(eventType: .dismissItemDetail) } }
                    )
                ) {
                    if let detail = viewModel.item.detailItem {
                        BasketItemDetailSheet(item: detail) {
                            viewModel.handleEvent(eventType: .dismissItemDetail)
                        }
                    }
                }
            } else {
                VStack(spacing: AppMetric.spacingMD) {
                    Image(systemName: "cart")
                        .font(.system(size: 48))
                        .foregroundColor(.secondary.opacity(0.4))
                    Text(L(.basketEmpty))
                        .font(AppFont.headline)
                        .foregroundColor(.secondary)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
        }
        .background(Color(.systemBackground))
        .alert(L(.clearBasket), isPresented: $viewModel.item.showClearAlert) {
            Button(L(.clear), role: .destructive) {
                viewModel.handleEvent(eventType: .confirmClear)
            }
            Button(L(.cancel), role: .cancel) {}
        } message: {
            Text(L(.clearBasketConfirm))
        }
        .sheet(isPresented: $viewModel.item.showApproveSheet) {
            BasketApproveSheet(
                items: viewModel.item.basket?.items ?? [],
                isConfirmed: $viewModel.item.isApproveConfirmed,
                onCancel: {
                    viewModel.item.showApproveSheet = false
                },
                onConfirm: {
                    viewModel.handleEvent(eventType: .confirmApprove)
                }
            )
        }
        .sheet(isPresented: $viewModel.item.showClosingTypeSheet) {
            ClosingTypeSheet(
                initialType: viewModel.item.basket?.closingType,
                onDismiss: { viewModel.item.showClosingTypeSheet = false },
                onConfirm: { type in
                    viewModel.handleEvent(eventType: .confirmClosingType(type))
                }
            )
        }
        .alert(
            editingPayment == .cash ? L(.cash) : L(.byTerminal),
            isPresented: Binding(
                get: { editingPayment != nil },
                set: { if !$0 { editingPayment = nil } }
            )
        ) {
            TextField("0", text: $paymentDraft)
                .keyboardType(.decimalPad)
            Button(L(.back), role: .cancel) {}
            Button(L(.confirm)) { applyPaymentEdit() }
        }
        .onChange(of: paymentDraft) { newValue in
            // Android bilan bir xil: faqat raqam/nuqta qabul qilinadi,
            // jami summadan oshiq qiymat kiritish rad etiladi.
            // Qo'shimcha: boshidagi ortiqcha nollar yig'iladi ("000" -> "0",
            // "05" -> "5") — 0 turgan joyda cheksiz nol terib bo'lmaydi.
            let filtered = normalizeLeadingZeros(newValue.filter { $0.isNumber || $0 == "." })
            let total = viewModel.item.basket?.calculateTotal() ?? 0
            if filtered.isEmpty {
                lastValidPaymentDraft = ""
                if newValue != filtered { paymentDraft = filtered }
            } else if let value = Double(filtered), value <= total {
                lastValidPaymentDraft = filtered
                if newValue != filtered { paymentDraft = filtered }
            } else {
                paymentDraft = lastValidPaymentDraft
            }
        }
    }

    /// Boshidagi ortiqcha nollarni yig'adi: "000" -> "0", "05" -> "5",
    /// lekin kasr nolini saqlaydi: "0.5" -> "0.5".
    private func normalizeLeadingZeros(_ text: String) -> String {
        var result = text
        while result.count > 1, result.hasPrefix("0"), !result.hasPrefix("0.") {
            result.removeFirst()
        }
        return result
    }

    private func emptyActionCard(icon: String, text: String, onTap: @escaping () -> Void) -> some View {
        Button(action: onTap) {
            VStack(spacing: AppMetric.spacingSM) {
                Image(systemName: icon)
                    .font(.system(size: 28))
                    .foregroundColor(AppColor.brand)
                Text(text)
                    .font(AppFont.bodyMedium)
                    .foregroundColor(.primary)
                    .multilineTextAlignment(.center)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, AppMetric.spacingXL)
            .background(Color(.systemGray6))
            .clipShape(RoundedRectangle(cornerRadius: AppMetric.radiusLG))
        }
        .buttonStyle(.plain)
    }

    private func clientHeaderView(basket: BasketResponse) -> some View {
        VStack(alignment: .leading, spacing: AppMetric.spacingSM) {
            Text(basket.branch?.name ?? "")
                .font(AppFont.headline)
                .foregroundColor(.primary)
                .frame(maxWidth: .infinity, alignment: .center)
                .multilineTextAlignment(.center)

            Divider()

            infoRow(label: "INN/PINFL", value: basket.client?.customer?.identifier ?? "—")
            if let closingType = basket.closingType {
                infoRow(
                    label: L(.saleType),
                    value: closingType == 1 ? L(.saleTypeElectronic) : L(.saleTypeFiscal)
                )
            }
        }
        .padding(AppMetric.cardPadding)
        .background(AppColor.successSoft)
        .clipShape(RoundedRectangle(cornerRadius: AppMetric.cardRadius))
        .padding(.horizontal, AppMetric.spacingLG)
        .padding(.top, AppMetric.spacingMD)
    }

    private func infoRow(label: String, value: String) -> some View {
        HStack {
            Text(label).font(AppFont.caption).foregroundColor(.secondary)
            Spacer()
            Text(value).font(AppFont.captionMedium).foregroundColor(.primary)
        }
    }

    private func totalSection(basket: BasketResponse) -> some View {
        let total = basket.calculateTotal()
        return HStack {
            Text(formatAmount(total))
                .font(AppFont.title2)
                .foregroundColor(AppColor.brand)
            Spacer()
        }
        .padding(.horizontal, AppMetric.spacingLG)
        .padding(.top, AppMetric.spacingMD)
    }

    private func paymentSection(basket: BasketResponse) -> some View {
        let total = basket.calculateTotal()
        let card = Double(viewModel.item.card) ?? 0
        let cash = max(total - card, 0)

        return VStack(spacing: AppMetric.spacingMD) {
            paymentRow(label: L(.cash), value: cash) {
                startEditingPayment(.cash, currentValue: cash)
            }
            paymentRow(label: L(.byTerminal), value: card) {
                startEditingPayment(.card, currentValue: card)
            }
        }
        .padding(.horizontal, AppMetric.spacingLG)
        .padding(.top, AppMetric.spacingMD)
    }

    /// Android `SalesPaymentChangeView` bilan bir xil: ikkala qator ham bosiladi,
    /// tahrir alert-dialog orqali qilinadi.
    private func paymentRow(label: String, value: Double, onEdit: @escaping () -> Void) -> some View {
        HStack {
            Text(label).font(AppFont.callout).foregroundColor(.secondary)
            Spacer()
            Button(action: onEdit) {
                HStack(spacing: AppMetric.spacingXS) {
                    Image(.pencil)
                        .resizable()
                        .frame(width: 13, height: 13)
                        .foregroundColor(.secondary)
                    Text(formatAmount(value))
                        .font(AppFont.calloutMedium)
                        .foregroundColor(.primary)
                }
                .contentShape(Rectangle())
            }
            .buttonStyle(.plain)
        }
    }

    /// Katta summalarda "%g" ilmiy ko'rinishga o'tib ketadi — shuning uchun
    /// butun son bo'lsa Int, aks holda ikki xonali kasr ishlatamiz.
    private func paymentString(_ value: Double) -> String {
        value.truncatingRemainder(dividingBy: 1) == 0
            ? String(Int(value))
            : String(format: "%.2f", value)
    }

    private func startEditingPayment(_ field: PaymentField, currentValue: Double) {
        paymentDraft = currentValue > 0 ? paymentString(currentValue) : ""
        lastValidPaymentDraft = paymentDraft
        editingPayment = field
    }

    /// Yagona manba — `item.card` (Android'dagi `payWithCard`):
    /// naqd tahrirlansa card = total - qiymat, terminal tahrirlansa card = qiymat.
    private func applyPaymentEdit() {
        guard let field = editingPayment,
              let basket = viewModel.item.basket else { return }
        let total = basket.calculateTotal()
        let value = min(Double(paymentDraft) ?? 0, total)
        let newCard = field == .cash ? (total - value) : value
        viewModel.item.card = newCard > 0 ? paymentString(newCard) : ""
    }
}

// MARK: - Sales Item Row

struct SalesItemRow: View {
    let item: ItemData
    let index: Int

    private var displayIndex: String {
        let n = index + 1
        return n < 10 ? "0\(n)." : "\(n)."
    }

    var body: some View {
        VStack(alignment: .leading, spacing: AppMetric.spacingXS) {
            HStack(alignment: .top, spacing: AppMetric.spacingXS) {
                Text(displayIndex)
                    .font(AppFont.calloutMedium)
                    .foregroundColor(.secondary)
                Text(item.product_name ?? "")
                    .font(AppFont.calloutSemibold)
                    .foregroundColor(.primary)
                    .fixedSize(horizontal: false, vertical: true)
            }

            HStack {
                HStack(spacing: AppMetric.spacingXS) {
                    Image(.money)
                    Text(formatAmount(item.unitPriceWithVat))
                        .font(AppFont.calloutMedium)
                        .foregroundColor(AppColor.brand)
                }
                Spacer()
                SalesQuantityBadge(item: item)
            }
        }
        .padding(.horizontal, AppMetric.spacingLG)
        .padding(.vertical, AppMetric.spacingSM)
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

// MARK: - Closing Type Sheet (Android SalesTypeAskingBottomSheet)

/// Sotuv turini tanlash — Android `SalesTypeAskingBottomSheet` bilan bir xil:
/// ikkita variant (elektron hisob-faktura / OFD fiskal chek), tur tanlanmaguncha
/// "Tasdiqlash" tugmasi o'chiq turadi.
struct ClosingTypeSheet: View {
    let onDismiss: () -> Void
    let onConfirm: (Int) -> Void

    @State private var selectedType: Int?

    init(initialType: Int?, onDismiss: @escaping () -> Void, onConfirm: @escaping (Int) -> Void) {
        self.onDismiss = onDismiss
        self.onConfirm = onConfirm
        self._selectedType = State(initialValue: initialType)
    }

    var body: some View {
        VStack(spacing: AppMetric.spacingLG) {
            BottomSheetHeader(title: L(.selectSaleType), onClose: onDismiss)

            HStack(spacing: AppMetric.spacingLG) {
                typeCard(title: L(.saleTypeElectronic), type: 1)
                typeCard(title: L(.saleTypeFiscal), type: 2)
            }
            .padding(.horizontal, AppMetric.spacingLG)

            Button {
                if let type = selectedType { onConfirm(type) }
            } label: {
                Text(L(.confirm))
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .frame(height: 52)
                    .background(AppColor.brand)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                    .opacity(selectedType != nil ? 1 : 0.5)
            }
            .disabled(selectedType == nil)
            .padding(.horizontal, AppMetric.spacingLG)

            Spacer(minLength: 0)
        }
        .background(Color(.systemBackground))
        .bottomSheetChrome(detents: [.height(300)])
    }

    private func typeCard(title: String, type: Int) -> some View {
        Button {
            selectedType = type
        } label: {
            Text(title)
                .font(.system(size: 16, weight: .medium))
                .foregroundColor(.primary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, AppMetric.spacingMD)
                .frame(maxWidth: .infinity)
                .frame(height: 96)
                .background(Color(.systemGray6))
                .clipShape(RoundedRectangle(cornerRadius: 20))
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(selectedType == type ? AppColor.brand : Color.clear, lineWidth: 1.5)
                )
        }
        .buttonStyle(.plain)
    }
}

// MARK: - Quantity Badge (Android SalesQuantityInItem)

/// Markirovkali tovarda "skanerlangan / jami" badge'lari (holatga qarab rang),
/// markirovkasizda faqat jami son — Android `SalesQuantityInItem` bilan bir xil.
struct SalesQuantityBadge: View {
    let item: ItemData

    /// Rang mantiqi (Android bilan bir xil): 0 — qizil, jamidan kam — sariq, to'liq — yashil.
    private var markColor: Color {
        let scanned = item.mark_quantity ?? 0
        let total = item.quantity ?? 0
        if scanned == 0 { return AppColor.danger }
        if scanned < total { return AppColor.warning }
        return AppColor.success
    }

    private func qtyString(_ value: Double?) -> String {
        guard let q = value else { return "0" }
        return q.truncatingRemainder(dividingBy: 1) == 0
            ? String(Int(q))
            : String(format: "%.2f", q)
    }

    var body: some View {
        HStack(spacing: 4) {
            if item.has_marking == true {
                Text(qtyString(item.mark_quantity))
                    .font(AppFont.callout)
                    .foregroundColor(markColor)
                    .padding(.horizontal, 6)
                    .background(markColor.opacity(0.25))
                    .clipShape(RoundedRectangle(cornerRadius: 8))

                Text("/")
                    .font(AppFont.callout)
                    .foregroundColor(.secondary)
            }

            Text(qtyString(item.quantity))
                .font(AppFont.calloutMedium)
                .foregroundColor(.primary)
                .padding(.horizontal, 6)
                .padding(.vertical, 1)
                .background(Color(.systemGray6))
                .clipShape(RoundedRectangle(cornerRadius: 8))
        }
    }
}

// MARK: - Approve Sheet

struct BasketApproveSheet: View {
    let items: [ItemData]
    @Binding var isConfirmed: Bool
    let onCancel: () -> Void
    let onConfirm: () -> Void

    var body: some View {
        VStack(spacing: 0) {
            BottomSheetHeader(title: L(.submit), onClose: onCancel)

            Divider()

            ScrollView {
                VStack(spacing: 0) {
                    ForEach(Array(items.enumerated()), id: \.element.id) { index, item in
                        ApproveItemRow(item: item, index: index)
                            .background(index % 2 == 0 ? Color(.systemGray6).opacity(0.6) : Color.clear)
                    }
                }
            }

            Divider()

            Button {
                isConfirmed.toggle()
            } label: {
                HStack(spacing: 10) {
                    Image(systemName: isConfirmed ? "checkmark.square.fill" : "square")
                        .font(.system(size: 22))
                        .foregroundColor(isConfirmed ? AppColor.brand : .secondary)
                    Text(L(.agreeHandover))
                        .font(.system(size: 15, weight: .medium))
                        .foregroundColor(.primary)
                    Spacer()
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 14)
            }
            .buttonStyle(.plain)

            Divider()

            HStack(spacing: 12) {
                Button {
                    onCancel()
                } label: {
                    Text(L(.back))
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(.primary)
                        .frame(maxWidth: .infinity)
                        .frame(height: 48)
                        .background(Color(.systemGray6))
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                }

                Button {
                    if isConfirmed { onConfirm() }
                } label: {
                    Text(L(.confirm))
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 48)
                        .background(AppColor.brand)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                        .opacity(isConfirmed ? 1 : 0.5)
                }
                .disabled(!isConfirmed)
            }
            .padding(16)
        }
        .background(Color(.systemBackground))
        .bottomSheetChrome()
    }
}

private struct ApproveItemRow: View {
    let item: ItemData
    let index: Int

    private var displayIndex: String {
        let n = index + 1
        return n < 10 ? "0\(n)." : "\(n)."
    }

    var body: some View {
        HStack(alignment: .top, spacing: 6) {
            Text(displayIndex)
                .font(.system(size: 15, weight: .medium))
                .foregroundColor(.secondary)
            Text(item.product_name ?? "")
                .font(.system(size: 15, weight: .medium))
                .foregroundColor(.primary)
                .frame(maxWidth: .infinity, alignment: .leading)
                .fixedSize(horizontal: false, vertical: true)
            SalesQuantityBadge(item: item)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 10)
    }
}

// MARK: - Edit Item Sheet

struct BasketEditItemSheet: View {
    let item: ItemData
    let isPriceEditable: Bool
    let isSubmitting: Bool
    let onDismiss: () -> Void
    let onConfirm: (_ price: Double, _ units: [BasketUnitPayload]) -> Void

    @State private var priceText: String = ""
    @State private var quantities: [Int: String] = [:]   
    @FocusState private var focusedField: Int?

    // Faqat product_unit_id'si bor unitlar tahrirlanadi — update payloadi shu id'ni talab qiladi.
    private var editableUnits: [BasketItemUnit] {
        (item.units ?? []).filter { $0.product_unit_id != nil }
    }

    private var priceValue: Double {
        Double(priceText.replacingOccurrences(of: ",", with: ".")) ?? 0
    }

    private func quantityValue(_ unitId: Int) -> Double {
        Double((quantities[unitId] ?? "").replacingOccurrences(of: ",", with: ".")) ?? 0
    }

    private var hasAnyQuantity: Bool {
        editableUnits.contains { quantityValue($0.product_unit_id ?? -1) > 0 }
    }

    private var isValid: Bool {
        hasAnyQuantity && (!isPriceEditable || priceValue > 0)
    }

    var body: some View {
        VStack(spacing: 0) {
            BottomSheetHeader(title: item.product_name ?? "", onClose: onDismiss)

            ScrollView {
                VStack(spacing: 12) {
                    if isPriceEditable {
                        labeledField(id: -1, title: L(.price), text: $priceText, placeholder: "0")
                    }

                    ForEach(Array(editableUnits.enumerated()), id: \.offset) { _, unit in
                        let uid = unit.product_unit_id ?? -1
                        labeledField(
                            id: uid,
                            title: unit.unit ?? L(.quantityLabel),
                            text: Binding(
                                get: { quantities[uid] ?? "" },
                                set: { quantities[uid] = $0 }
                            ),
                            placeholder: "0"
                        )
                    }
                }
                .padding(.horizontal, 16)
                .padding(.top, 4)
                .padding(.bottom, 16)
            }

            Button {
                let units: [BasketUnitPayload] = editableUnits.compactMap { unit in
                    guard let uid = unit.product_unit_id else { return nil }
                    let qty = quantityValue(uid)
                    guard qty > 0 else { return nil }
                    return BasketUnitPayload(unit_id: uid, quantity: qty)
                }
                let price = isPriceEditable ? priceValue : item.unitPriceWithVat
                onConfirm(price, units)
            } label: {
                HStack {
                    if isSubmitting {
                        ProgressView()
                            .progressViewStyle(.circular)
                            .tint(.white)
                    } else {
                        Text(L(.confirm))
                            .font(.system(size: 16, weight: .semibold))
                    }
                }
                .frame(maxWidth: .infinity)
                .frame(height: 52)
                .foregroundColor(.white)
                .background(isValid ? AppColor.brand : Color(.systemGray3))
                .clipShape(RoundedRectangle(cornerRadius: 12))
            }
            .disabled(!isValid || isSubmitting)
            .padding(16)
        }
        .background(Color(.systemBackground))
        .bottomSheetChrome()
        .onAppear {
            if priceText.isEmpty {
                priceText = item.unitPriceWithVat > 0 ? String(format: "%.0f", item.unitPriceWithVat) : ""
            }
            for unit in editableUnits {
                if let uid = unit.product_unit_id, quantities[uid] == nil {
                    quantities[uid] = unit.quantity.map { String(format: "%g", $0) } ?? ""
                }
            }
        }
    }

    private func labeledField(id: Int, title: String, text: Binding<String>, placeholder: String) -> some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(title)
                .font(.system(size: 14, weight: .medium))
                .foregroundColor(.secondary)
            TextField(placeholder, text: text)
                .focused($focusedField, equals: id)
                .keyboardType(.decimalPad)
                .font(.system(size: 16, weight: .medium))
                .padding(.horizontal, 14)
                .frame(height: 48)
                .background(Color(.systemGray6))
                .clipShape(RoundedRectangle(cornerRadius: 12))
                .contentShape(Rectangle())
                .onTapGesture { focusedField = id }
        }
    }

}

// MARK: - Item Detail Sheet (read-only, tahrirlab bo'lmaydigan tovar uchun)

struct BasketItemDetailSheet: View {
    let item: ItemData
    let onDismiss: () -> Void

    private func qtyString(_ value: Double?) -> String {
        guard let q = value else { return "0" }
        return q.truncatingRemainder(dividingBy: 1) == 0
            ? String(Int(q))
            : String(format: "%.2f", q)
    }

    private var totalQtyValue: String {
        if item.has_marking == true {
            return "\(qtyString(item.mark_quantity)) / \(qtyString(item.quantity))"
        }
        return Loc.quantity(qtyString(item.quantity))
    }

    var body: some View {
        VStack(spacing: 0) {
            BottomSheetHeader(title: item.product_name ?? "", onClose: onDismiss)

            VStack(spacing: 0) {
                detailRow(title: L(.price), value: formatAmount(item.unitPriceWithVat))

                if let units = item.units, !units.isEmpty {
                    ForEach(Array(units.enumerated()), id: \.offset) { _, unit in
                        Divider().padding(.horizontal, 12)
                        detailRow(
                            title: unit.unit ?? L(.unit),
                            value: Loc.quantity(qtyString(unit.quantity))
                        )
                    }
                }

                Divider().padding(.horizontal, 12)
                detailRow(title: L(.totalQuantity), value: totalQtyValue)
            }
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(Color(.systemGray5), lineWidth: 1)
            )
            .padding(.horizontal, 16)
            .padding(.bottom, 24)

            Spacer(minLength: 0)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        .background(Color(.systemBackground))
        .bottomSheetChrome()
    }

    private func detailRow(title: String, value: String) -> some View {
        HStack(alignment: .top) {
            Text(title)
                .font(.system(size: 15))
                .foregroundColor(.secondary)
            Spacer(minLength: 12)
            Text(value)
                .font(.system(size: 15, weight: .medium))
                .foregroundColor(.primary)
                .multilineTextAlignment(.trailing)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 14)
    }
}
