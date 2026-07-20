import UIKit

class BaseViewController: UIViewController {
    var statusBarStyle: UIStatusBarStyle = .default {
        didSet {
            UIView.animate(withDuration: 0.2) {
                self.setNeedsStatusBarAppearanceUpdate()
            }
        }
    }

    override var preferredStatusBarStyle: UIStatusBarStyle { statusBarStyle }

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.backButtonTitle = ""
        setupSubviews()
    }
}

@objc extension BaseViewController {
    func setupSubviews() {
        embedSubviews()
        setSubviewsConstraints()
    }

    func embedSubviews() {}
    func setSubviewsConstraints() {}
}
