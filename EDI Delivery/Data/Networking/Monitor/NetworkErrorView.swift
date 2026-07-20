import UIKit

@MainActor
class NetworkErrorView {
    private static let viewTag = 2026
    
    class func start() {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let keyWindow = windowScene.windows.first(where: { $0.isKeyWindow }) else { return }
        
        if keyWindow.viewWithTag(viewTag) != nil { return }
        
        let loadV = UIView()
        loadV.backgroundColor = .appBrand
        loadV.tag = viewTag
        loadV.frame = keyWindow.bounds
        let stack: UIStackView = {
            let stack = UIStackView()
            stack.axis = .vertical
            stack.alignment = .center
            stack.distribution = .equalSpacing
            stack.spacing = 15
            return stack
        }()
        
        let imgV: UIImageView = {
            let img = UIImageView()
            img.image = UIImage(systemName: "wifi.slash")?.withTintColor(.white, renderingMode: .alwaysOriginal)
            img.contentMode = .scaleAspectFit
            return img
        }()
        
        let lbl: UILabel = {
            let lbl = UILabel()
            lbl.text = "Sizda internet bilan bog'liq muammo mavjud!"
            lbl.textAlignment = .center
            lbl.numberOfLines = 2
            lbl.font = .systemFont(ofSize: 20, weight: .medium)
            lbl.textColor = .white
            return lbl
        }()
        
        loadV.addSubview(stack)
        stack.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stack.leadingAnchor.constraint(equalTo: loadV.leadingAnchor, constant: 20),
            stack.trailingAnchor.constraint(equalTo: loadV.trailingAnchor, constant: -20),
            stack.centerYAnchor.constraint(equalTo: loadV.centerYAnchor),
            imgV.heightAnchor.constraint(equalToConstant: 180),
            imgV.widthAnchor.constraint(equalToConstant: 200)
        ])
        
        stack.addArrangedSubview(imgV)
        stack.addArrangedSubview(lbl)
        keyWindow.addSubview(loadV)
    }
    
    @objc class func refreshData() {
        UINotificationFeedbackGenerator().notificationOccurred(.error)
        self.start()
    }
    
    class func stop() {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let keyWindow = windowScene.windows.first(where: { $0.isKeyWindow }) else { return }
        if let errorView = keyWindow.viewWithTag(viewTag) {
            errorView.removeFromSuperview()
        }
    }
}
