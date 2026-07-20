import UIKit

protocol EditBranchNavigation {
    func popBack()
}

class EditBranchCoordinator: Coordinator {
    private(set) weak var viewController: BaseViewController?
    private let branch: BranchResponse

    init(branch: BranchResponse) {
        self.branch = branch
    }

    func start() -> BaseViewController {
        let viewModel = EditBranchViewModel(
            navigation: self,
            branchService: DIContainer.shared.resolver.get(),
            branch: branch
        )
        let viewController = EditBranchViewController(viewModel: viewModel)
        self.viewController = viewController
        return viewController
    }
}

extension EditBranchCoordinator: EditBranchNavigation {
    func popBack() {
        viewController?.navigationController?.popViewController(animated: true)
    }
}
