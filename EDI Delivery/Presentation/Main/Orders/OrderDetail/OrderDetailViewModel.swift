import UIKit
internal import Combine

enum OrderDetailEvent {
    case viewDidLoad
    case didTapStartSelling
    case didTapCancel
    case confirmCancel
}

class OrderDetailViewModel: ObservableObject {

    private let orderService: OrderService
    private let basketService: BasketService
    private let navigation: OrderDetailNavigation
    private let orderId: String

    @Published var item: OrderDetailUIState

    init(navigation: OrderDetailNavigation, orderService: OrderService, basketService: BasketService, orderId: String) {
        self.item = .init()
        self.navigation = navigation
        self.orderService = orderService
        self.basketService = basketService
        self.orderId = orderId
    }

    @MainActor
    func handleEvent(eventType: OrderDetailEvent) {
        switch eventType {
        case .viewDidLoad:
            fetchDetail()
        case .didTapStartSelling:
            startSellingProcess()
        case .didTapCancel:
            item.showCancelAlert = true
        case .confirmCancel:
            cancelOrder()
        }
    }

    private func startSellingProcess() {
        Loader.start()
        basketService.getBaskets { [weak self] result in
            guard let self else { return }
            DispatchQueue.main.async {
                switch result {
                case .success(let existing):
                    if let basket = existing {
                        Loader.stop()
                        if basket.delivery_order_id == self.orderId {
                            self.navigation.routeToBasket()
                        } else {
                            Alert.showAlert(forState: .warning, message: L(.basketHasOtherProducts), vibrationType: .warning)
                        }
                    } else {
                        self.registerBasket()
                    }
                case .failure:
                    self.registerBasket()
                }
            }
        }
    }

    private func registerBasket() {
        basketService.registerBasket(model: BasketRegisterRequest(delivery_order_id: orderId)) { [weak self] result in
            guard let self else { return }
            DispatchQueue.main.async {
                Loader.stop()
                switch result {
                case .success:
                    self.navigation.routeToBasket()
                case .failure:
                    break
                }
            }
        }
    }

    private func cancelOrder() {
        let reason = item.cancelReason.isEmpty ? "Bekor qilindi" : item.cancelReason
        Loader.start()
        orderService.cancelOrder(id: orderId, reason: reason) { [weak self] result in
            guard let self else { return }
            DispatchQueue.main.async {
                Loader.stop()
                switch result {
                case .success:
                    self.item.cancelReason = ""
                    Alert.showAlert(forState: .success, message: L(.orderCancelled), vibrationType: .success)
                    self.fetchDetail()
                case .failure:
                    break
                }
            }
        }
    }

    private func fetchDetail() {
        Loader.start()
        orderService.getOrderDetail(id: orderId) { [weak self] result in
            guard let self else { return }
            DispatchQueue.main.async {
                Loader.stop()
                switch result {
                case .success(let detail):
                    self.item.detail = detail
                case .failure:
                    break
                }
            }
        }
    }
}
