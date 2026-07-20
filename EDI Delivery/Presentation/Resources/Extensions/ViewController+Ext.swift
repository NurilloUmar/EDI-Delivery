import UIKit
import SwiftUI

extension UIViewController {
    enum NavBarAppearanceType {
        case defaultType, transparent, opaque
    }
    
    fileprivate var statusBarTag: Int { 123456789 }
    
    var hasNotch: Bool {
        UIApplication.shared.hasBottomNotch
    }
    
    var prefersLargeTitle: Bool {
        get {
            navigationController?.navigationBar.prefersLargeTitles ?? true
        } set {
            navigationController?.navigationBar.prefersLargeTitles = newValue
        }
    }
    
    var actualKeyWindow: UIWindow? {
        UIApplication.shared.actualKeyWindow
    }
    
    var safeAreaInsets: UIEdgeInsets {
        actualKeyWindow?.safeAreaInsets ?? .zero
    }
    
    var statusBarView: UIView? {
        view.viewWithTag(statusBarTag)
    }
    
    
    @discardableResult
        func setNavBarAppearance(with type: NavBarAppearanceType, backgroundColor: UIColor? = nil, shouldApply: Bool = true) -> UINavigationBarAppearance {
            let appearance = UINavigationBarAppearance()
            
            switch type {
            case .defaultType:
                appearance.configureWithDefaultBackground()
            case .transparent:
                appearance.configureWithTransparentBackground()
            case .opaque:
                appearance.configureWithOpaqueBackground()
            }
            
            appearance.shadowColor = .clear
            appearance.shadowImage = UIImage()
            
            if let backgroundColor {
                appearance.backgroundColor = backgroundColor
            }
            
            if shouldApply {
                navigationItem.standardAppearance = appearance
                navigationItem.compactAppearance = appearance
                navigationItem.scrollEdgeAppearance = appearance
                
                if #available(iOS 15.0, *) {
                    navigationItem.compactScrollEdgeAppearance = appearance
                }
            }
            
            return appearance
        }
}

extension UIViewController {
    
    func addSwiftUI(view swiftUIView: some View, backgroundColor: UIColor = .white) {
        let hostingController = UIHostingController(rootView: swiftUIView)
        addChild(hostingController)
        hostingController.view.frame = view.bounds
        hostingController.view.backgroundColor = backgroundColor
        hostingController.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.addSubview(hostingController.view)
        hostingController.didMove(toParent: self)
    }
}

