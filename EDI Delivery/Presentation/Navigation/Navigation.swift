import UIKit

protocol Coordinator: AnyObject {
    var viewController: BaseViewController? { get }
    func start()
    func start() -> BaseViewController
}

extension Coordinator {
    
    var navController: UINavigationController? {
        viewController?.navigationController
    }
    
    var topController: UIViewController? {
        UIApplication.shared.topViewController()
    }
    
    func start() {}
    func start() -> BaseViewController { .init() }
    
    func pushController(_ controller: UIViewController, animated: Bool = true) {
        controller.hidesBottomBarWhenPushed = true
        navController?.pushViewController(controller, animated: animated)
    }
    
    func present(controller: UIViewController, animated: Bool = true, completion: EmptyClosure? = nil) {
        if navController != nil {
            navController?.present(controller, animated: animated, completion: completion)
        } else {
            viewController?.present(controller, animated: animated, completion: completion)
        }
    }
    
    func pushTo(coordinator: Coordinator) {
        let controller: BaseViewController = coordinator.start()
        controller.hidesBottomBarWhenPushed = true
        navController?.pushViewController(controller, animated: true)
    }

    /// Joriy controller'ni nav stack'dan chiqarib, o'rniga yangi coordinator'ni
    /// qo'yadi — yangi ekrandan orqaga qaytilganda joriy ekran o'tkazib yuboriladi
    /// (masalan, OrderDetail → Savat: orqaga bosilganda Buyurtmalar ro'yxatiga tushadi).
    func replaceTop(with coordinator: Coordinator) {
        let controller: BaseViewController = coordinator.start()
        controller.hidesBottomBarWhenPushed = true
        guard let navController else { return }
        var stack = navController.viewControllers
        if let current = viewController, let index = stack.firstIndex(of: current) {
            stack[index] = controller
            navController.setViewControllers(stack, animated: true)
        } else {
            navController.pushViewController(controller, animated: true)
        }
    }
    
    func presentTo(coordinator: Coordinator) {
        let controller: BaseViewController = coordinator.start()
        navController?.present(controller, animated: true)
    }
    
    func presentShareScreen(with items: [Any]) {
        let acitivity = UIActivityViewController(activityItems: items, applicationActivities: nil)
        present(controller: acitivity)
    }
    
    func presentSettings() {
        guard let url = URL(string: UIApplication.openSettingsURLString) else { return }
        UIApplication.shared.open(url)
    }
    
    func presentURL(path: String) {
        guard let url = URL(string: path),
              UIApplication.shared.canOpenURL(url) else {
            return
        }
        UIApplication.shared.open(url)
    }
    
    func isNavStackContainsController<T: UIViewController>(ofType type: T.Type) -> Bool {
        let topController = UIApplication.shared.topViewController()
        let controllers = topController?.navigationController?.viewControllers ?? []
        
        return controllers.contains(where: { $0.isKind(of: T.self) })
    }
    
//    func isSelectedTab(ofType type: TabItemType) -> Bool {
//        let topController = UIApplication.shared.topViewController()
//        let index = topController?.tabBarController?.selectedIndex
//        return index == type.tag
//    }
    
    func setRootControllerToWindow(_ controller: UIViewController) {
        guard (viewController?.actualKeyWindow) != nil else { return }
        
            if controller is UITabBarController {
                self.viewController?.actualKeyWindow?.rootViewController = controller
            } else {
                let navController = BaseNavigationController(rootViewController: controller)
                self.viewController?.actualKeyWindow?.rootViewController = navController
            }
    }
    
    
}
