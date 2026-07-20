internal import Foundation

struct BasketRegisterRequest: Codable {
    var delivery_order_id: String?
    var client_branch_id: String?
    var items: [BasketItemPayload]?
}

struct BasketApproveRequest: Codable {
    var basket_id: String
    var type: Int
    var cash: Double?
    var card: Double?
    var version: Int = 2
}

struct BasketClearRequest: Codable {
    var basket_id: String
}

struct BasketDeleteItemRequest: Codable {
    var basket_id: String
    var basket_item_id: String
}

struct BasketUpdateClientRequest: Codable {
    var basket_id: String
    var client_id: Int?
    var client_branch_id: String?
}

struct BasketAddItemRequest: Codable {
    var basket_id: String
    var item: BasketItemPayload
}

struct BasketUpdateItemRequest: Codable {
    var basket_id: String
    var item: BasketItemUpdatePayload
}

struct BasketItemPayload: Codable {
    var product_id: Int
    var price: Double?
    var units: [BasketUnitPayload]
}

struct BasketItemUpdatePayload: Codable {
    var basket_item_id: String
    var price: Double?
    var units: [BasketUnitPayload]
}

struct BasketUnitPayload: Codable {
    var unit_id: Int
    var quantity: Double
}
