import UIKit
import Network

class NetworkMonitor {
    static let shared = NetworkMonitor()
    
    private let queue = DispatchQueue(label: "NetworkMonitorBackgroundQueue")
    let monitor: NWPathMonitor
    
    public private(set) var isConnected: Bool = false
    public private(set) var connectionType: ConnectionType = .unknown
    
    enum ConnectionType {
        case wifi
        case cellular
        case ethernet
        case unknown
    }
    
    private init() {
        self.monitor = NWPathMonitor()
    }
    
    public func startMonitoring() {
        monitor.start(queue: queue)
        monitor.pathUpdateHandler = { [weak self] path in
            guard let self = self else { return }
            self.isConnected = (path.status == .satisfied)
            self.updateConnectionType(path)
            DispatchQueue.main.async {
                if self.isConnected {
                    NetworkErrorView.stop()
                } else {
                    NetworkErrorView.start()
                }
            }
        }
    }
    
    public func stopMonitoring() {
        monitor.cancel()
    }
    
    private func updateConnectionType(_ path: NWPath) {
        if path.usesInterfaceType(.wifi) {
            connectionType = .wifi
        } else if path.usesInterfaceType(.cellular) {
            connectionType = .cellular
        } else if path.usesInterfaceType(.wiredEthernet) {
            connectionType = .ethernet
        } else {
            connectionType = .unknown
        }
    }
    
}
