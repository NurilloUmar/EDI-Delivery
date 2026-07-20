internal import Foundation

struct BasketUIState {
    var basket: BasketResponse?
    var cash: String = ""
    var card: String = ""
    var showClearAlert: Bool = false
    var showApproveSheet: Bool = false
    var isApproveConfirmed: Bool = false
    var showClosingTypeSheet: Bool = false
    var editingItem: ItemData?
    var detailItem: ItemData?
    var isUpdatingItem: Bool = false
}
