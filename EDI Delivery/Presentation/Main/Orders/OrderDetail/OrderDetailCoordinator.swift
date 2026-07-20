import UIKit

protocol OrderDetailNavigation {
    func routeToBasket()
}

class OrderDetailCoordinator: Coordinator {
    private(set) weak var viewController: BaseViewController?
    private let orderId: String

    init(orderId: String) {
        self.orderId = orderId
    }

    func start() -> BaseViewController {
        let viewModel = OrderDetailViewModel(
            navigation: self,
            orderService: DIContainer.shared.resolver.get(),
            basketService: DIContainer.shared.resolver.get(),
            orderId: orderId
        )
        let viewController = OrderDetailViewController(viewModel: viewModel)
        self.viewController = viewController
        return viewController
    }
}

extension OrderDetailCoordinator: OrderDetailNavigation {
    func routeToBasket() {
        // Push emas — OrderDetail'ni savat bilan almashtiramiz: savatdan orqaga
        // qaytilganda "Sotuvni boshlash" ekraniga emas, Buyurtmalar ro'yxatiga tushadi.
        replaceTop(with: BasketCoordinator())
    }
}
