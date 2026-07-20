import UIKit

class BaseCollectionViewCell: UICollectionViewCell {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
}

@objc extension BaseCollectionViewCell {
    func setupView() {
        embedSubviews()
        setSubviewsConstraints()
    }
    
    func embedSubviews() {}
    func setSubviewsConstraints() {}
}
