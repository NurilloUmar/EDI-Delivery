import UIKit

protocol ProductNavigation {
    func routeToAuth()
}

class ProductCoordinator: Coordinator {
    private(set) weak var viewController: BaseViewController?
    func start() -> BaseViewController {
        let viewModel = ProductViewModel(
            navigation: self,
            productService: DIContainer.shared.resolver.get()
        )
        let viewController = ProductViewController(viewModel: viewModel)
        self.viewController = viewController
        return viewController
    }
}

extension ProductCoordinator: ProductNavigation {
    func routeToAuth() {
    }
}
