internal import Foundation

struct ProductResponse: Codable, Identifiable {
    var id: Int?
    var name: String?
    var image: String?
    var price: Double?
    var vatRate: Double?
    var executorId: Int?
    var catalogCode: String?
    var catalogName: String?
    var packageCode: String?
    var packageName: String?
    var code: String?
    var origin: Int?
    var barcode: String?
    var measurement: String?
    var hasMarking: Bool?
    var unit: [ProductUnitResponse]?

    var priceWithVat: Double?
    
    enum CodingKeys: String, CodingKey {
        case id, name, image, price, code, origin, barcode, measurement, unit
        case vatRate     = "vat_rate"
        case executorId  = "executor_id"
        case catalogCode = "catalog_code"
        case catalogName = "catalog_name"
        case packageCode = "package_code"
        case packageName = "package_name"
        case hasMarking  = "has_marking"
        case priceWithVat = "price_with_vat"
    }
}

struct ProductUnitResponse: Codable, Identifiable {
    var id: Int?
    var name: String?
    var quantity: Int?
    var isDefault: Bool?
    var systemUnit: Bool?
    var isActive: Bool?
    var main: Bool?

    enum CodingKeys: String, CodingKey {
        case id, name, quantity, main
        case isDefault  = "is_default"
        case systemUnit = "system_unit"
        case isActive   = "is_active"
    }
}

struct ExecutorData: Codable {
    var id: Int?
    var name: String?
    var identifier: String?
}
