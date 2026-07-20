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
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(handleLanguageChange),
            name: .appLanguageDidChange,
            object: nil
        )
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        localize()
    }

    @objc private func handleLanguageChange() {
        localize()
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}

@objc extension BaseViewController {
    func localize() {}

    func setupSubviews() {
        embedSubviews()
        setSubviewsConstraints()
    }

    func embedSubviews() {}
    func setSubviewsConstraints() {}
}
