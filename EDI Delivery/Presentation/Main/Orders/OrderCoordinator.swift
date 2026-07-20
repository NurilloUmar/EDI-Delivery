import UIKit

protocol OrderNavigation {
    func routeToOrderDetail(id: String)
}

class OrderCoordinator: Coordinator {
    private(set) weak var viewController: BaseViewController?
    func start() -> BaseViewController {
        let viewModel = OrderViewModel(
            navigation: self,
            orderService: DIContainer.shared.resolver.get()
        )
        let viewController = OrderViewController(viewModel: viewModel)
        self.viewController = viewController
        return viewController
    }
}

extension OrderCoordinator: OrderNavigation {
    func routeToOrderDetail(id: String) {
        let coordinator = OrderDetailCoordinator(orderId: id)
        pushTo(coordinator: coordinator)
    }
}
