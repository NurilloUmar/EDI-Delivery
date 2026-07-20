import UIKit
internal import Combine

enum OrderEvent {
    case viewDidLoad
    case refresh
    case filterByDate(Date)
    case didSelectOrder(id: String)
}

class OrderViewModel: ObservableObject {

    private let orderService: OrderService
    private let navigation: OrderNavigation

    @Published var item: OrderUIState

    init(navigation: OrderNavigation, orderService: OrderService) {
        self.item = .init()
        self.navigation = navigation
        self.orderService = orderService
    }

    var filteredOrders: [OrderResponse] {
        guard !item.searchText.isEmpty else { return item.items }
        return item.items.filter {
            ($0.number ?? "").localizedCaseInsensitiveContains(item.searchText) ||
            ($0.clientBranch?.name ?? "").localizedCaseInsensitiveContains(item.searchText) ||
            ($0.clientBranch?.code ?? "").localizedCaseInsensitiveContains(item.searchText)
        }
    }

    var isToday: Bool {
        Calendar.current.isDateInToday(item.selectedDate)
    }

    @MainActor
    func handleEvent(eventType: OrderEvent) {
        switch eventType {
        case .viewDidLoad, .refresh:
            fetchOrders(date: item.selectedDate)
        case .filterByDate(let date):
            item.selectedDate = date
            fetchOrders(date: date)
        case .didSelectOrder(let id):
            navigation.routeToOrderDetail(id: id)
        }
    }

    func fetchOrders(date: Date) {
        let formatter = DateFormatter.apiDateFormatter
        let dateStr = formatter.string(from: date)
        let model = OrderRequest(date_start: dateStr, date_end: dateStr)

        Loader.start()
        orderService.getOrders(model: model) { [weak self] result in
            guard let self else { return }
            DispatchQueue.main.async {
                Loader.stop()
                switch result {
                case .success(let orders):
                    self.item.items = orders
                case .failure:
                    break
                }
            }
        }
    }
}
