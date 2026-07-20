internal import Foundation

struct OrderDetailUIState {
    var detail: OrderDetailResponse?
    var showCancelAlert: Bool = false
    var cancelReason: String = ""
}
