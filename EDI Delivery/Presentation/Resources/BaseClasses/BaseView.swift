import UIKit

class BaseView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

@objc extension BaseView {
    func setupView() {
        embedSubviews()
        setSubviewsConstraints()
    }
    
    func embedSubviews() {}
    func setSubviewsConstraints() {}
}
