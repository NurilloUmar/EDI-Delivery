import SwiftUI

struct DocumentView: View {

    @ObservedObject var viewModel: DocumentViewModel
    @State private var showDatePicker = false

    private var isToday: Bool {
        Calendar.current.isDateInToday(viewModel.item.selectedDate)
    }

    var body: some View {
        VStack(spacing: 0) {
            
            VStack(spacing: 8) {
                
                HStack(spacing: 0) {
                    SearchBar(text: $viewModel.item.searchText)
                    Button {
                        showDatePicker = true
                    } label: {
                        ZStack(alignment: .topTrailing) {
                            Image(.filter)
                                .font(.system(size: 18))
                                .foregroundColor(.blue)
                                .frame(width: 44, height: 44)
                                .background(Color(.systemGray6))
                                .clipShape(RoundedRectangle(cornerRadius: 10))
                            if !isToday {
                                Circle()
                                    .fill(Color.red)
                                    .frame(width: 8, height: 8)
                                    .padding(8)
                            }
                        }
                    }
                    .padding(.top, 12)
                    .padding(.trailing, 16)
                }
                
                HStack(spacing: 6) {
                    Image(systemName: "calendar")
                        .font(.system(size: 13))
                        .foregroundColor(.blue)
                    Text(viewModel.item.selectedDate, format: .dateTime.day().month().year())
                        .font(.system(size: 13, weight: .medium))
                        .foregroundColor(.secondary)
                    Spacer()
                }
                .padding(.horizontal, 16)
                .padding(.bottom, 8)
            }
            
            totalSumBar

            if viewModel.filteredDocuments.isEmpty {
                Spacer()
                VStack(spacing: 12) {
                    Image(systemName: "doc.text.magnifyingglass")
                        .font(.system(size: 48))
                        .foregroundColor(.secondary.opacity(0.5))
                    Text(L(.noSales))
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(.secondary)
                }
                Spacer()
            } else {
                ScrollView {
                    LazyVStack(spacing: 12) {
                        ForEach(viewModel.filteredDocuments) { doc in
                            Button {
                                viewModel.handleEvent(eventType: .didSelectDocument(id: doc.id ?? ""))
                            } label: {
                                HistoryRow(doc: doc)
                            }
                            .buttonStyle(.plain)
                        }
                    }
                    .padding(.horizontal, 16)
                    .padding(.vertical, 8)
                }
                .scrollDismissesKeyboard(.immediately)
                .padding(.top, 2)
            }
        }
        .background(Color(.systemBackground))
        .sheet(isPresented: $showDatePicker) {
            DatePickerSheet(selectedDate: $viewModel.item.selectedDate) { date in
                viewModel.handleEvent(eventType: .filterByDate(date))
            }
        }
    }

    private var totalSumBar: some View {
        HStack {
            Spacer()
            Text("∑ \(formatAmount(viewModel.totalSum))")
                .font(.system(size: 22, weight: .medium))
                .foregroundColor(.white)
            Spacer()
        }
        .frame(height: 64)
        .background(AppColor.brand)
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .padding(.horizontal, 16)
        .padding(.bottom, 8)
    }
}

// MARK: - History Row

struct HistoryRow: View {
    let doc: DocumentResponse

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(doc.clientBranch?.name ?? "")
                .font(.system(size: 20, weight: .medium))
                .foregroundColor(.primary)
                .lineLimit(1)

            HStack {
                Text(L(.saleNumber))
                    .font(.system(size: 14))
                    .foregroundColor(.secondary)
                Spacer()
                Text(doc.number ?? "")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(.primary)
            }

            Divider()

            HStack {
                Text(L(.totalAmount))
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(AppColor.brand)
                Spacer()
                Text(formatAmount(doc.totalWithVat ?? doc.totalPrice ?? 0))
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.primary)
            }
        }
        .padding(16)
        .background(Color(.systemGray6))
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }
}
