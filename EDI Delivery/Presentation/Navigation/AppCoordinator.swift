import UIKit

protocol AuthSessionDelegate: AnyObject {
    func routeToMain()
    func routeToAuth()
    func reloadRoot()
}

enum AuthSession {
    static weak var delegate: AuthSessionDelegate?
}

class AppCoordinator: AuthSessionDelegate {

    private let window: UIWindow?

    init(window: UIWindow?) {
        self.window = window
    }

    func start() {
        AuthSession.delegate = self
        if hasToken() {
            routeToMain()
        } else {
            routeToAuth()
        }
        window?.makeKeyAndVisible()
    }

    func routeToMain() {
        let coordinator = MainCoordinator()
        let controller = coordinator.start()
        window?.rootViewController = BaseNavigationController(rootViewController: controller)
        window?.makeKeyAndVisible()
    }

    func routeToAuth() {
        let coordinator = LoginCoordinator()
        let controller = coordinator.start()
        window?.rootViewController = BaseNavigationController(rootViewController: controller)
        window?.makeKeyAndVisible()
    }

    func reloadRoot() {
        if hasToken() {
            routeToMain()
        } else {
            routeToAuth()
        }
    }

    private func hasToken() -> Bool {
        return Cache.share.getUserToken() != nil
    }
}
