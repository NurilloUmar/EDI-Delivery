import SwiftUI

// MARK: - Product View

struct ProductView: View {
    
    @ObservedObject var viewModel: ProductViewModel
    
    var body: some View {
        VStack(spacing: 0) {
            SearchBar(text: $viewModel.item.searchText)
            
            if viewModel.filteredProducts.isEmpty {
                Spacer()
                VStack(spacing: 12) {
                    Image(systemName: "shippingbox")
                        .font(.system(size: 48))
                        .foregroundColor(.secondary.opacity(0.5))
                    Text(L(.noProducts))
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(.secondary)
                }
                Spacer()
            } else {
                ScrollView {
                    LazyVStack(spacing: 12) {
                        ForEach(viewModel.filteredProducts) { product in
                            ProductRow(
                                product: product,
                                isInBasket: viewModel.isInBasket(productId: product.id),
                                onTap: {
                                    viewModel.handleEvent(eventType: .didTapAddToBasket(product))
                                },
                                onMenu: {
                                    viewModel.handleEvent(eventType: .didTapDetail(product))
                                }
                            )
                            .padding(.horizontal, 16)
                        }
                    }
                    .padding(.vertical, 8)
                }
                .scrollDismissesKeyboard(.immediately)
                .padding(.top, 8)
            }
        }
        .background(Color(.systemBackground))
        .sheet(
            isPresented: Binding(
                get: { viewModel.item.detailProduct != nil },
                set: { if !$0 { viewModel.handleEvent(eventType: .dismissDetail) } }
            )
        ) {
            if let product = viewModel.item.detailProduct {
                ProductDetailSheet(product: product) {
                    viewModel.handleEvent(eventType: .dismissDetail)
                }
            }
        }
        .sheet(
            isPresented: Binding(
                get: { viewModel.item.basketProduct != nil },
                set: { if !$0 { viewModel.handleEvent(eventType: .dismissBasket) } }
            )
        ) {
            if let product = viewModel.item.basketProduct {
                ProductBasketSheet(
                    product: product,
                    isSubmitting: viewModel.item.isSubmitting,
                    onDismiss: { viewModel.handleEvent(eventType: .dismissBasket) },
                    onConfirm: { price, units in
                        viewModel.handleEvent(
                            eventType: .confirmAddToBasket(
                                productId: product.id ?? 0,
                                price: price,
                                units: units
                            )
                        )
                    }
                )
            }
        }
    }
}

// MARK: - Product Row

struct ProductRow: View {
    
    let product: ProductResponse
    let isInBasket: Bool
    let onTap: () -> Void
    let onMenu: () -> Void
    
    private var priceText: String {
        formatAmount(product.priceWithVat ?? 0)
    }
    
    var body: some View {
        
        Button(action: onTap) {
            VStack(alignment: .leading, spacing: 12) {
                
                HStack(alignment: .top) {
                    
                    if product.hasMarking == true {
                        Image(systemName: "checkmark.seal.fill")
                            .font(.system(size: 15))
                            .foregroundColor(AppColor.success)
                            .padding(.top, 4)
                     }

                    Text(product.name ?? "")
                        .font(.system(size: 20, weight: .medium))
                        .foregroundColor(.primary)
                        .multilineTextAlignment(.leading)
                        .lineLimit(2)
                    Spacer()


                    Button(action: onMenu) {
                        Image(systemName: "ellipsis")
                            .font(.system(size: 18))
                            .foregroundColor(.primary)
                            .frame(width: 60, height: 44, alignment: .top)
                            .contentShape(Rectangle())
                    }
                    .buttonStyle(.plain)
                    
                }
                
                HStack(spacing: 12) {
                    HStack(spacing: 6) {
                        Image(.money)
                            .resizable()
                            .frame(width: 16, height: 16)
                            .foregroundColor(AppColor.brand)
                        Text(priceText)
                            .font(.system(size: 16, weight: .medium))
                            .foregroundColor(AppColor.brand)
                    }
                    
                    Spacer()
                    
                    if let barcode = product.barcode, !barcode.isEmpty {
                        HStack(spacing: 6) {
                            Image(systemName: "barcode")
                                .font(.system(size: 14))
                                .foregroundColor(.secondary)
                            Text(barcode)
                                .font(.system(size: 13))
                                .foregroundColor(.secondary)
                                .lineLimit(1)
                        }
                    }
                }
            }
            .padding(16)
            .background(Color(.systemGray6))
            .clipShape(RoundedRectangle(cornerRadius: 16))
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(isInBasket ? AppColor.success : Color.clear, lineWidth: 1)
            )
        }
        .buttonStyle(.plain)
    }
}

// MARK: - Product Detail Sheet

struct ProductDetailSheet: View {
    let product: ProductResponse
    let onDismiss: () -> Void
    
    var body: some View {
        
        VStack(spacing: 0) {

            BottomSheetHeader(title: product.name ?? "", onClose: onDismiss)

            VStack(spacing: 0) {
                detailRow(title: L(.price), value: formatAmount(product.priceWithVat ?? 0))
                Divider().padding(.horizontal, 12)
                detailRow(title: L(.barcode),     value: product.barcode)
                Divider().padding(.horizontal, 12)
                detailRow(title: L(.ikpuCode),    value: product.catalogCode)
                Divider().padding(.horizontal, 12)
                detailRow(title: L(.ikpuName),    value: product.catalogName)
                Divider().padding(.horizontal, 12)
                detailRow(title: L(.packageCode), value: product.packageCode)
                Divider().padding(.horizontal, 12)
                detailRow(title: L(.packageName), value: product.packageName)
                Divider().padding(.horizontal, 12)
                detailRow(title: L(.vatRate),     value: product.vatRate.map { String(format: "%g", $0) })
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
    
    private func detailRow(title: String, value: String?) -> some View {
        HStack(alignment: .top) {
            Text(title)
                .font(.system(size: 15))
                .foregroundColor(.secondary)
            Spacer(minLength: 12)
            Text(value ?? "-")
                .font(.system(size: 15, weight: .medium))
                .foregroundColor(.primary)
                .multilineTextAlignment(.trailing)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 14)
    }
}

// MARK: - Product Basket Sheet (add product to basket with units & price)

struct ProductBasketSheet: View {
    let product: ProductResponse
    let isSubmitting: Bool
    let onDismiss: () -> Void
    let onConfirm: (_ price: Double, _ units: [BasketUnitPayload]) -> Void
    
    @State private var priceText: String = ""
    @State private var quantities: [Int: String] = [:]
    @FocusState private var focusedField: Int?
    
    private var units: [ProductUnitResponse] {
        product.unit ?? []
    }
    
    private var priceValue: Double {
        Double(priceText) ?? 0
    }
    
    private var hasAnyQuantity: Bool {
        quantities.contains { (_, v) in (Int(v) ?? 0) > 0 }
    }
    
    var body: some View {
        
        VStack(spacing: 0) {

            BottomSheetHeader(title: product.name ?? "", onClose: onDismiss)

            ScrollView {
                VStack(spacing: 12) {
                    labeledField(id: -1, title: L(.price), text: $priceText, placeholder: "0")
                    
                    ForEach(units) { unit in
                        labeledField(
                            id: unit.id ?? 0,
                            title: unit.name ?? L(.unit),
                            text: Binding(
                                get: { quantities[unit.id ?? 0] ?? "" },
                                set: { quantities[unit.id ?? 0] = $0.filter { $0.isNumber } }
                            ),
                            placeholder: "0"
                        )
                    }
                    
                    if units.isEmpty {
                        Text(L(.productHasNoUnit))
                            .font(.system(size: 14))
                            .foregroundColor(.secondary)
                            .padding(.top, 8)
                    }
                }
                .padding(.horizontal, 16)
                .padding(.top, 4)
                .padding(.bottom, 16)
            }
            
            Button {
                let payload: [BasketUnitPayload] = units.compactMap { unit in
                    guard let unitId = unit.id else { return nil }
                    let qty = Int(quantities[unitId] ?? "") ?? 0
                    guard qty > 0 else { return nil }
                    return BasketUnitPayload(unit_id: unitId, quantity: Double(qty))
                }
                onConfirm(priceValue, payload)
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
                .background(hasAnyQuantity && priceValue > 0 ? AppColor.brand : Color(.systemGray3))
                .clipShape(RoundedRectangle(cornerRadius: 12))
            }
            .disabled(!hasAnyQuantity || priceValue <= 0 || isSubmitting)
            .padding(16)
        }
        .background(Color(.systemBackground))
        .bottomSheetChrome()
        .onAppear {
            if priceText.isEmpty {
                priceText = product.priceWithVat.map { String(format: "%.0f", $0) } ?? ""
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
                .keyboardType(.numberPad)
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
