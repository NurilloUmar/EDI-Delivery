internal import Foundation

struct OrderUIState {
    var items: [OrderResponse] = []
    var searchText: String = ""
    var selectedDate: Date = Date()
}
