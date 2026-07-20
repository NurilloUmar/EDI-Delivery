import UIKit

protocol AuthSessionDelegate: AnyObject {
    func routeToMain()
    func routeToAuth()
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
        window?.rootViewController = TabBarController()
        window?.makeKeyAndVisible()
    }

    func routeToAuth() {
        let coordinator = LoginCoordinator()
        let controller = coordinator.start()
        window?.rootViewController = BaseNavigationController(rootViewController: controller)
        window?.makeKeyAndVisible()
    }

    private func hasToken() -> Bool {
        return Cache.share.getUserToken() != nil
    }
}
