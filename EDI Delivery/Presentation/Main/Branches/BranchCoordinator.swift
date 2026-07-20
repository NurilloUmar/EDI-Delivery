import UIKit

protocol BranchNavigation {
    func routeToAddClient()
    func routeToAddBranch()
    func routeToEditBranch(branch: BranchResponse)
    func routeToBasket()
}

class BranchCoordinator: Coordinator {
    private(set) weak var viewController: BaseViewController?
    func start() -> BaseViewController {
        let viewModel = BranchViewModel(
            navigation: self,
            branchService: DIContainer.shared.resolver.get(),
            basketService: DIContainer.shared.resolver.get()
        )
        let viewController = BranchViewController(viewModel: viewModel)
        self.viewController = viewController
        return viewController
    }
}

extension BranchCoordinator: BranchNavigation {
    func routeToAddClient() {
        pushTo(coordinator: AddClientCoordinator())
    }

    func routeToAddBranch() {
        pushTo(coordinator: AddBranchCoordinator())
    }

    func routeToEditBranch(branch: BranchResponse) {
        pushTo(coordinator: EditBranchCoordinator(branch: branch))
    }

    func routeToBasket() {
     
        if let existing = navController?.viewControllers.first(where: { $0 is BasketViewController }) {
            navController?.popToViewController(existing, animated: true)
        } else {
            pushTo(coordinator: BasketCoordinator())
        }
    }
}
