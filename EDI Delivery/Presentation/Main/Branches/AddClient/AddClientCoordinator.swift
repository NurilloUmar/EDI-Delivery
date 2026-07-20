import UIKit

protocol AddClientNavigation {
    func popBack()
}


class AddClientCoordinator: Coordinator {
    private(set) weak var viewController: BaseViewController?

    func start() -> BaseViewController {
        let viewModel = AddClientViewModel(
            navigation: self,
            branchService: DIContainer.shared.resolver.get()
        )
        let viewController = AddClientViewController(viewModel: viewModel)
        self.viewController = viewController
        return viewController
    }
    
}

extension AddClientCoordinator: AddClientNavigation {
    func popBack() {
        viewController?.navigationController?.popViewController(animated: true)
    }
}
