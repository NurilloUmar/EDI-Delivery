import UIKit

protocol AddBranchNavigation {
    func popBack()
}

class AddBranchCoordinator: Coordinator {
    private(set) weak var viewController: BaseViewController?

    func start() -> BaseViewController {
        let viewModel = AddBranchViewModel(
            navigation: self,
            branchService: DIContainer.shared.resolver.get()
        )
        let viewController = AddBranchViewController(viewModel: viewModel)
        self.viewController = viewController
        return viewController
    }
}

extension AddBranchCoordinator: AddBranchNavigation {
    func popBack() {
        viewController?.navigationController?.popViewController(animated: true)
    }
}
