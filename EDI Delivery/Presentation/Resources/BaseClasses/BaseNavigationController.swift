
import UIKit

class BaseNavigationController: UINavigationController {
    override var childForStatusBarStyle: UIViewController? {
        topViewController
    }
    
    override var childForStatusBarHidden: UIViewController? {
        topViewController
    }
}
