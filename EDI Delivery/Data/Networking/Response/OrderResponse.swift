internal import Foundation

struct OrderResponse: Codable, Identifiable {
    var id: String?
    var number: String?
    var date: String?
    var status: Int?
    var client: OrderClientData?
    var extraInfo: ExtraInfoData?
    var clientBranch: ClientBranch?

    enum CodingKeys: String, CodingKey {
        case id, number, date, status, client
        case extraInfo    = "extra_info"
        case clientBranch = "client_branch"
    }
}

struct OrderDetailResponse: Codable {
    var id: String?
    var number: String?
    var date: String?
    var status: Int?
    var client: OrderClientData?
    var extraInfo: ExtraInfoData?
    var clientBranch: ClientBranch?
    var items: [OrderLineItem]?

    enum CodingKeys: String, CodingKey {
        case id, number, date, status, client, items
        case extraInfo    = "extra_info"
        case clientBranch = "client_branch"
    }
}

struct OrderLineItem: Codable, Identifiable {
    var id: String?
    var quantity: Double?
    var price: Double?
    var vatRate: Int?
    var productName: String?
    var hasMark: Bool?

    enum CodingKeys: String, CodingKey {
        case id, quantity, price
        case vatRate     = "vat_rate"
        case productName = "product_name"
        case hasMark     = "has_mark"
    }
}

struct ClientBranch: Codable {
    var id: String?
    var name: String?
    var code: String?
}

struct OrderClientData: Codable {
    var id: Int?
    var name: String?
}

struct OrderDeliveryIdResponse: Codable {
    var deliveryOrderId: String?
    enum CodingKeys: String, CodingKey {
        case deliveryOrderId = "delivery_order_id"
    }
}

struct ExtraInfoData: Codable {
    var totalPrice: Double?
    var totalVat: Double?
    var totalWithVat: Double?
    var loadingPoint: LocationPoint?
    var unloadingPoint: LocationPoint?

    enum CodingKeys: String, CodingKey {
        case totalPrice      = "total_price"
        case totalVat        = "total_vat"
        case totalWithVat    = "total_with_vat"
        case loadingPoint    = "loading_point"
        case unloadingPoint  = "unloading_point"
    }
}

struct LocationPoint: Codable {
    var address: String?
    var longitude: Double?
    var latitude: Double?
    var districtName: String?
    var regionName: String?

    enum CodingKeys: String, CodingKey {
        case address
        case longitude
        case latitude
        case districtName = "district_name"
        case regionName   = "region_name"
    }
}
