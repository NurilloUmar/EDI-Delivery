import SwiftUI

// MARK: - Product View

struct ProductView: View {
    
    @ObservedObject var viewModel: ProductViewModel
    
    @State private var searchText: String = ""
    
    var body: some View {
        VStack(spacing: 0) {

            SearchBar(text: $searchText)

            ScrollView {
                VStack(spacing: 10) {
                    // viewModel'dagi to'g'ri arrayni to'g'ridan-to'g'ri beramiz
                    ForEach(viewModel.item.items) { product in
                        ProductRow(product: product)
                            .padding(.horizontal, 16)
                    }
                }
                .padding(.vertical, 10)
            }
        }
        .background(Color(.systemBackground))
        // .navigationTitle("Mahsulotlar")  // Kerak bo'lsa yoqing
    }
}


struct ProductRow: View {
    let product: ProductResponse

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack(alignment: .top) {
                Text(product.name ?? "")
                    .font(.system(size: 17, weight: .semibold))
                    .foregroundColor(.primary)
                    .fixedSize(horizontal: false, vertical: true)

                Spacer()

                Button {
                    // more actions
                } label: {
                    Image(systemName: "ellipsis")
                        .foregroundColor(.secondary)
                        .padding(.leading, 4)
                }
            }

            HStack {
                HStack(spacing: 6) {
                    Image(.money)
                        .font(.system(size: 14))
                        .foregroundColor(.white)
                        .padding(5)
                        .clipShape(RoundedRectangle(cornerRadius: 5))

                    Text("\(product.price?.formatted() ?? "") UZS")
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(.blue)
                }

                Spacer()

                HStack(spacing: 4) {
                    Image(systemName: "barcode")
                        .foregroundColor(product.barcode != nil ? .primary : .secondary)
                        .font(.system(size: 15))
                    if let barcode = product.barcode {
                        Text(barcode)
                            .font(.system(size: 13))
                            .foregroundColor(.secondary)
                    }
                }
            }
        }
        .padding(.horizontal, 18)
        .padding(.vertical, 16)
        .background(Color(.systemGray6))
        .clipShape(RoundedRectangle(cornerRadius: 14))
        .overlay(
            RoundedRectangle(cornerRadius: 14)
                .stroke(Color.green, lineWidth: 1)
        )
    }
}
