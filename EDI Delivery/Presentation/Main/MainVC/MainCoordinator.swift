import UIKit

protocol MainNavigation {
    func routeToProfile()
    func routeToProduct()
    func routeToBranch()
    func routeToOrder()
    func routeToBasket()
    func routeToDocument()
}

class MainCoordinator: Coordinator {
    private(set) weak var viewController: BaseViewController?
    func start() -> BaseViewController {
        let viewModel = MainViewModel(
            navigation: self,
            authService: DIContainer.shared.resolver.get()
        )
        let viewController = MainViewController(viewModel: viewModel)
        self.viewController = viewController
        return viewController
    }
}


extension MainCoordinator: MainNavigation {
    func routeToDocument() {
        let coordinator = DocumentCoordinator()
        pushTo(coordinator: coordinator)
    }
    
    func routeToBasket() {
        let coordinator = BasketCoordinator()
        pushTo(coordinator: coordinator)
    }
    
    
    func routeToOrder() {
        let coordinator = OrderCoordinator()
        pushTo(coordinator: coordinator)
    }
    
    func routeToBranch() {
        let coordinator = BranchCoordinator()
        pushTo(coordinator: coordinator)
    }
    
    func routeToProduct() {
        let coordinator = ProductCoordinator()
        pushTo(coordinator: coordinator)
    }
    
    func routeToProfile() {
        let coordinator = ProfileCoordinator()
        pushTo(coordinator: coordinator)
    }
    
}
