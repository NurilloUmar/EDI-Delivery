import UIKit

public protocol Closurable: AnyObject {}

public extension Closurable {
    
    func getContainer(for closure: @escaping (Self) -> Void) -> ClosureContainer<Self> {
        weak let weakSelf = self
        let container = ClosureContainer(closure: closure, caller: weakSelf)
        objc_setAssociatedObject(self, Unmanaged.passUnretained(self).toOpaque(), container as AnyObject?, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        return container
    }
}

public final class ClosureContainer<T: Closurable> {
    var closure: (T) -> Void
    var caller: T?

    public init(closure: @escaping (T) -> Void, caller: T?) {
        self.closure = closure
        self.caller = caller
    }

    @objc public func processHandler() {
        if let caller = caller {
            closure(caller)
        }
    }

    // target action
    public var action: Selector { #selector(processHandler) }
}


extension UIButton: Closurable {
    func addTarget(for event: UIControl.Event = .touchUpInside, closure: @escaping Closure<UIButton>) {
        let container = getContainer(for: closure)
        addTarget(container, action: container.action, for: event)
    }
}

extension UIRefreshControl: Closurable {
    func addTarget(for event: UIControl.Event = .valueChanged, closure: @escaping Closure<UIRefreshControl>) {
        let container = getContainer(for: closure)
        addTarget(container, action: container.action, for: event)
    }
}

extension UISlider: Closurable {
    func addTarget(for event: UIControl.Event = .valueChanged, closure: @escaping Closure<UISlider>) {
        let container = getContainer(for: closure)
        addTarget(container, action: container.action, for: event)
    }
}

extension UISwitch: Closurable {
    func addTarget(for event: UIControl.Event = .valueChanged, closure: @escaping Closure<UISwitch>) {
        let container = getContainer(for: closure)
        addTarget(container, action: container.action, for: event)
    }
}

extension UITextField: Closurable {
    func addTarget(for event: UIControl.Event = .editingChanged, closure: @escaping Closure<UITextField>) {
        let container = getContainer(for: closure)
        addTarget(container, action: container.action, for: event)
    }
}

extension UIDatePicker: Closurable {
    func addTarget(for event: UIControl.Event = .valueChanged, closure: @escaping Closure<UIDatePicker>) {
        let container = getContainer(for: closure)
        addTarget(container, action: container.action, for: event)
    }
}

extension UIGestureRecognizer: Closurable {
    convenience init(closure: @escaping Closure<UIGestureRecognizer>){
        self.init()
        
        let container = getContainer(for: closure)
        addTarget(container, action: container.action)
    }
}

extension UISwipeGestureRecognizer {
    public convenience init(direction: UISwipeGestureRecognizer.Direction, _ closure: @escaping (UISwipeGestureRecognizer) -> Void) {
        self.init()
        
        self.direction = direction
        let container = getContainer(for: closure)
        addTarget(container, action: container.action)
    }
}

extension UIBarButtonItem: Closurable {
    public convenience init(image: UIImage?, style: UIBarButtonItem.Style = .plain, closure: @escaping (UIBarButtonItem) -> Void) {
        self.init(image: image, style: style, target: nil, action: nil)

        let container = getContainer(for: closure)
        target = container
        action = container.action
    }

    public convenience init(title: String?, style: UIBarButtonItem.Style = .plain, closure: @escaping (UIBarButtonItem) -> Void) {
        self.init(title: title, style: style, target: nil, action: nil)

        let container = getContainer(for: closure)
        target = container
        action = container.action
    }
    
    public convenience init(_ item: SystemItem, closure: @escaping (UIBarButtonItem) -> Void) {
        self.init(barButtonSystemItem: item, target: nil, action: nil)
        
        let container = getContainer(for: closure)
        target = container
        action = container.action
    }
    
    public convenience init(customView: UIView, closure: @escaping (UIBarButtonItem) -> Void) {
        self.init(customView: customView)
        
        let container = getContainer(for: closure)
        target = container
        action = container.action
    }
    
}
