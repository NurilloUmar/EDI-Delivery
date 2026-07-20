import UIKit

protocol LoginNavigation {
    func routeToTabbar()
}

class LoginCoordinator: Coordinator {
    private(set) weak var viewController: BaseViewController?
    func start() -> BaseViewController {
        let viewModel = LoginViewModel(
            navigation: self,
            authService: DIContainer.shared.resolver.get()
        )
        let viewController = LoginViewController(viewModel: viewModel)
        self.viewController = viewController
        return viewController
    }
}

extension LoginCoordinator: LoginNavigation {
    func routeToTabbar() {
        AuthSession.delegate?.routeToMain()
    }
}
