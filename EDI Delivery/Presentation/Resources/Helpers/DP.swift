import UIKit

extension CGFloat {
    var dp: CGFloat {
        let size = UIApplication.shared.actualKeyWindow?.screen.bounds.size ?? UIScreen.main.bounds.size
        var coefficient: CGFloat = 0.0
        if (size.height / size.width) > 16/9 {
            coefficient = UIScreen.main.bounds.width / 375
        } else {
            coefficient = UIScreen.main.bounds.height / 667
        }
        return self * coefficient
    }
}

extension Int {
    var dp: CGFloat {
        let size = UIApplication.shared.actualKeyWindow?.screen.bounds.size ?? UIScreen.main.bounds.size
        var coefficient: CGFloat = 0.0
        if (size.height / size.width) > 16/9 {
            coefficient = UIScreen.main.bounds.width / 375
        } else {
            coefficient = UIScreen.main.bounds.height / 667
        }
        return CGFloat(self) * coefficient
    }
}

extension Double {
    var dp: CGFloat {
        let size = UIApplication.shared.actualKeyWindow?.screen.bounds.size ?? UIScreen.main.bounds.size
        var coefficient: CGFloat = 0.0
        if (size.height / size.width) > 16/9 {
            coefficient = UIScreen.main.bounds.width / 375
        } else {
            coefficient = UIScreen.main.bounds.height / 667
        }
        return CGFloat(self) * coefficient
    }
}
