import UIKit.UIApplication

extension UIApplication {
    var actualKeyWindow: UIWindow? {
        // Get connected scenes
        connectedScenes
            // Keep only active scenes, onscreen and visible to the user
            .filter { $0.activationState == .foregroundActive }
            // Keep only the first `UIWindowScene`
            .first(where: { $0 is UIWindowScene })
            // Get its associated windows
            .flatMap({ $0 as? UIWindowScene })?.windows
        // Finally, keep only the key window
            .first(where: \.isKeyWindow) ?? windows.first
    }
    
    func topMostViewController(base: UIViewController? = nil) -> UIViewController? {
        let baseVC = base ?? keyWindow?.rootViewController
        if let nav = baseVC as? UINavigationController {
            return topMostViewController(base: nav.visibleViewController)
        }
        if let tab = baseVC as? UITabBarController {
            return topMostViewController(base: tab.selectedViewController)
        }
        if let presented = baseVC?.presentedViewController {
            return topMostViewController(base: presented)
        }
        return baseVC
    }
    
    var keyWindow: UIWindow? {
        return connectedScenes
            .compactMap { $0 as? UIWindowScene }
            .flatMap { $0.windows }
            .first { $0.isKeyWindow }
    }
    
    func isPresentedController<T: UIViewController>(ofType type: T.Type) -> Bool {
        let currentController = UIApplication.shared.topViewController()
        let presentingController = currentController?.presentationController?.presentedViewController
        
        if presentingController?.isKind(of: type) == true || currentController?.isKind(of: type) == true {
            return true
        }
        
        return false
    }
    
    func topViewController(controller: UIViewController? = UIApplication.shared.actualKeyWindow?.rootViewController) -> UIViewController? {
        if let navigationController = controller as? UINavigationController {
            return topViewController(controller: navigationController.visibleViewController)
        }
        
        if let tabController = controller as? UITabBarController {
            if let selected = tabController.selectedViewController {
                return topViewController(controller: selected)
            }
        }
        
        if let presented = controller?.presentedViewController {
            return topViewController(controller: presented)
        }
        
        return controller
    }
    
    var hasDynamicIsland: Bool {
        let topInset = actualKeyWindow?.safeAreaInsets.top ?? 0.0
        return topInset > 44.0
    }
    
    var hasTopNotch: Bool {
        let topInset = actualKeyWindow?.safeAreaInsets.top ?? 0.0
        return topInset < 50.0 && topInset > 40.0
    }
    
    var hasBottomNotch: Bool {
        actualKeyWindow?.safeAreaInsets.bottom ?? 0.0 > 20.0
    }
    
}
