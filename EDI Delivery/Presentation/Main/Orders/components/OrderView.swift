import SwiftUI

// MARK: - Order Status

enum OrderStatus: Int {
    case draft             = 1
    case confirmed         = 2
    case inProgress        = 3
    case documentCreated   = 4
    case temporaryCanceled = 8

    var title: String {
        switch self {
        case .draft:             return "Qoralama"
        case .confirmed:         return "Tasdiqlandi"
        case .inProgress:        return "Jarayonda"
        case .documentCreated:   return "Hujjat yaratildi"
        case .temporaryCanceled: return "Vaqtincha bekor"
        }
    }

    var color: Color {
        switch self {
        case .draft:             return .secondary
        case .confirmed:         return AppColor.brand
        case .inProgress:        return .orange
        case .documentCreated:   return .orange
        case .temporaryCanceled: return .red
        }
    }
}

// MARK: - Order View

struct OrderView: View {

    @State private var showDatePicker = false
    @ObservedObject var viewModel: OrderViewModel

    var body: some View {
        
        VStack(spacing: 0) {
            
            VStack(spacing: 10){
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
                            
                            if !viewModel.isToday {
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
            }
            
            if viewModel.filteredOrders.isEmpty {
                Spacer()
                VStack(spacing: 12) {
                    Image(systemName: "doc.text.magnifyingglass")
                        .font(.system(size: 48))
                        .foregroundColor(.secondary.opacity(0.5))
                    Text(L(.noOrders))
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(.secondary)
                }
                Spacer()
            } else {
                
                ScrollView {
                    LazyVStack(spacing: 12) {
                        ForEach(viewModel.filteredOrders, id: \.id) { order in
                            Button {
                                viewModel.handleEvent(eventType: .didSelectOrder(id: order.id ?? ""))
                            } label: {
                                OrderRow(order: order)
                                    .padding(.horizontal, 16)
                            }
                            .buttonStyle(.plain)
                        }
                    }
                    .padding(.vertical, 0)
                }
                .scrollDismissesKeyboard(.immediately)
                .padding(.top, 8)
            }
        }
        .background(Color(.systemBackground))
        .sheet(isPresented: $showDatePicker) {
            DatePickerSheet(selectedDate: $viewModel.item.selectedDate) { date in
                viewModel.handleEvent(eventType: .filterByDate(date))
            }
        }
    }
}

// MARK: - DatePicker Sheet

struct DatePickerSheet: View {

    @Environment(\.dismiss) private var dismiss
    @Binding var selectedDate: Date

    let onApply: (Date) -> Void

    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                DatePicker(
                    "",
                    selection: $selectedDate,
                    displayedComponents: .date
                )
                .datePickerStyle(.graphical)
                .padding(.horizontal, 8)

                Spacer()

                Button {
                    onApply(selectedDate)
                    dismiss()
                } label: {
                    Text(L(.filter))
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 50)
                        .background(Color.blue)
                        .clipShape(RoundedRectangle(cornerRadius: 14))
                        .padding(.horizontal, 16)
                        .padding(.bottom, 32)
                }
            }
            .navigationTitle(L(.selectDate))
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button(L(.close)) { dismiss() }
                }
            }
        }
    }
}

// MARK: - Order Row

struct OrderRow: View {
    let order: OrderResponse

    private var status: OrderStatus? {
        guard let s = order.status else { return nil }
        return OrderStatus(rawValue: s)
    }

    private var statusTitle: String {
        status?.title ?? "Bajarildi"
    }

    private var statusColor: Color {
        status?.color ?? .green
    }

    private var formattedDate: String {
        guard let dateStr = order.date else { return "" }
        let input = DateFormatter()
        input.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let output = DateFormatter()
        output.dateFormat = "dd.MM.yyyy"
        return input.date(from: dateStr).map { output.string(from: $0) } ?? dateStr
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack(alignment: .top) {
                VStack(alignment: .leading, spacing: 0) {
                    Text(order.number ?? "")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(.secondary)
                        .lineLimit(1)
                    Text(formattedDate)
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(.secondary)
                        .lineLimit(1)
                }

                Spacer()

                Text(statusTitle)
                    .font(.system(size: 12, weight: .medium))
                    .foregroundColor(statusColor)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(statusColor.opacity(0.2))
                    .overlay(
                        RoundedRectangle(cornerRadius: 6)
                            .stroke(statusColor, lineWidth: 1)
                    )
                    .clipShape(RoundedRectangle(cornerRadius: 6))
            }

            Text(order.clientBranch?.name ?? "")
                .font(.system(size: 20, weight: .medium))
                .foregroundColor(.primary)
                .lineLimit(2)
                .padding(.top, 4)

            HStack {
                Text(L(.totalValue))
                    .font(.system(size: 14))
                    .foregroundColor(.secondary)
                Spacer()
                Text(formatAmount(order.extraInfo?.totalWithVat ?? 0))
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(AppColor.brand)
            }
            .padding(.top, 4)
        }
        .padding(16)
        .background(Color(.systemGray6))
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }
}
