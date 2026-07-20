internal import Foundation

struct OrderRequest: Codable {
    var limit: Int = 500
    var date_start: String?
    var date_end: String?
}

struct OrderCancelRequest: Codable {
    var description: String
}
