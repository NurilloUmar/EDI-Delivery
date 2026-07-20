
import UIKit

protocol ProfileNavigation {
    func routeToAuth()
}

class ProfileCoordinator: Coordinator {
    
    private(set) weak var viewController: BaseViewController?
    
    func start() -> BaseViewController {
        let viewModel = ProfileViewModel(
            navigation: self,
            authService: DIContainer.shared.resolver.get()
        )
        let viewController = ProfileViewController(viewModel: viewModel)
        self.viewController = viewController
        return viewController
    }
    
}

extension ProfileCoordinator: ProfileNavigation {
    
    func routeToAuth() {
        AuthSession.delegate?.routeToAuth()
    }
    
}
