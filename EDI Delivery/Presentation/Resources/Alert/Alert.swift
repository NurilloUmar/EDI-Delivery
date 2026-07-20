
import UIKit
import AudioToolbox

let screenSize = UIScreen.main.bounds

class Alert {
   static var completion : ((Bool) -> Void)?
    enum AlertType {
        case warning
        case success
        case error
        case unknown
        case progress
    }
    
    static var timer : Timer? = nil
    
    class func showAlert(forState: AlertType, message: String, vibrationType: Vibration, duration: TimeInterval = 4, userInteration: Bool = true) {
                
        let view = UIView(frame: CGRect(x: 10, y: -90, width: screenSize.width-20, height: 60))
        view.layer.cornerRadius = 8
        view.clipsToBounds = true
        view.layer.masksToBounds = false
        view.addShadow(offset: CGSize(width: 0, height: 0), color: .black, radius: 3, opacity: 0.4)
        view.backgroundColor = .white
        
        
        let img: UIImageView = {
            let img = UIImageView()
            img.tintColor = .white
            img.image = UIImage(systemName: "info.circle")
            return img
        }()
        
        let titleLbl = UILabel()
        titleLbl.frame = view.frame
        titleLbl.textColor = .white
        titleLbl.minimumScaleFactor = 1
        titleLbl.adjustsFontSizeToFitWidth = true
        titleLbl.numberOfLines = 3
        titleLbl.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        titleLbl.textAlignment = .center
        
        let stack: UIStackView = {
            let stack = UIStackView()
            stack.axis = .horizontal
            stack.alignment = .center
            stack.distribution = .fill
            stack.spacing = 10
            return stack
        }()
        
        
        stack.addArrangedSubview(img)
        img.translatesAutoresizingMaskIntoConstraints = false
        img.heightAnchor.constraint(equalToConstant: 20).isActive = true
        img.widthAnchor.constraint(equalToConstant: 20).isActive = true
        stack.addArrangedSubview(titleLbl)
       
        view.addSubview(stack)
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 15).isActive = true
        stack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -15).isActive = true
        stack.topAnchor.constraint(equalTo: view.topAnchor, constant: 4).isActive = true
        stack.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -4).isActive = true
        
        
    
        
        view.tag = 9981
        
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let window = windowScene.windows.first(where: { $0.isKeyWindow }) {
            if let vi = window.viewWithTag(9981) {
                timer?.invalidate()
                vi.removeFromSuperview()
            }
            window.addSubview(view)
            vibrate(type: vibrationType)
        }

        
        UIView.animate(withDuration: 0.6, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0.6, options: .curveEaseIn, animations: {
            view.transform = CGAffineTransform(translationX: 0, y: 90 + (view.window?.windowScene?.statusBarManager?.statusBarFrame.height ?? 0) )
        })
        
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(closeBtnPressed))
        swipeLeft.direction = .up
        view.addGestureRecognizer(swipeLeft)
        
        titleLbl.text = message
        
        switch forState {
        case .warning: view.backgroundColor = .appWarning
        case .error:   view.backgroundColor = .appDanger
        case .success: view.backgroundColor = .appSuccess
        case .unknown: view.backgroundColor = .appNeutral
        case .progress: view.backgroundColor = .appInfo
        }
        timer = Timer.scheduledTimer(timeInterval: duration, target: self, selector: #selector(Alert.closeBtnPressed), userInfo: nil, repeats: false)        
    }
    
    @objc class func closeBtnPressed() {
        completion?(true)
        timer?.invalidate()
        
        // Use UIWindowScene.windows for iOS 15.0+
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let window = windowScene.windows.first(where: { $0.isKeyWindow }),
           let view = window.viewWithTag(9981) {
            UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.8, options: .curveEaseIn, animations: {
                view.transform = .identity
            }) { _ in
                view.removeFromSuperview()
            }
        }
    }

    
    private class func vibrate(type: Vibration){
        switch type {
        case .error:
            UINotificationFeedbackGenerator().notificationOccurred(.error)
        case .success:
            UINotificationFeedbackGenerator().notificationOccurred(.success)
        case .warning:
            UINotificationFeedbackGenerator().notificationOccurred(.warning)
        case .light:
            UIImpactFeedbackGenerator(style: .light).impactOccurred()
        case .medium:
            UIImpactFeedbackGenerator(style: .medium).impactOccurred()
        case .heavy:
            UIImpactFeedbackGenerator(style: .heavy).impactOccurred()
        case .soft:
            if #available(iOS 13.0, *) {
                UIImpactFeedbackGenerator(style: .soft).impactOccurred()
            }
        case .rigid:
            if #available(iOS 13.0, *) {
                UIImpactFeedbackGenerator(style: .rigid).impactOccurred()
            }
        case .selection:
            UISelectionFeedbackGenerator().selectionChanged()
        case .oldSchool:
            AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
        }
    }
    
}
