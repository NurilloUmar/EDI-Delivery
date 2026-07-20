import UIKit

protocol BasketNavigation {
    func routeToAuth()
    func routeToProduct()
    func routeToSalePoints()
}

//New 

class BasketCoordinator: Coordinator {
    private(set) weak var viewController: BaseViewController?
    func start() -> BaseViewController {
        let viewModel = BasketViewModel(
            navigation: self,
            basketService: DIContainer.shared.resolver.get()
        )
        let viewController = BasketViewController(viewModel: viewModel)
        self.viewController = viewController
        return viewController
    }
}

extension BasketCoordinator: BasketNavigation {
    func routeToAuth() {
    }

    func routeToProduct() {
        pushTo(coordinator: ProductCoordinator())
    } 

    func routeToSalePoints() {
        pushTo(coordinator: BranchCoordinator())
    }
}
