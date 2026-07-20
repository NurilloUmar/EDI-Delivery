import UIKit

class BaseCollectionReusableView: UICollectionReusableView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
}

@objc extension BaseCollectionReusableView {
    func setupView() {
        embedSubviews()
        setSubviewsConstraints()
    }
    
    func embedSubviews() {}
    func setSubviewsConstraints() {}
}
