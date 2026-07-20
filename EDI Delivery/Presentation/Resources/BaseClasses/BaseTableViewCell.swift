import UIKit

class BaseTableViewCell: UITableViewCell {
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

@objc extension BaseTableViewCell {
    func setupView() {
        embedSubviews()
        setSubviewsConstraints()
    }
    func embedSubviews() {}
    func setSubviewsConstraints() {}
}


//+82010934266
