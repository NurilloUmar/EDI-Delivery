internal import Foundation

struct BasketResponse: Codable, Identifiable {
    var id: String?
    var delivery_order_id: String?
    var client: ClientData?
    var branch: BranchData?
    var closingType: Int?
    var totalPrice: Double?
    var totalVat: Double?
    var totalWithVat: Double?
    var items: [ItemData]?
    var version: Int?

    enum CodingKeys: String, CodingKey {
        case id, delivery_order_id, client, branch, items, version
        case closingType  = "closing_type"
        case totalPrice   = "total_price"
        case totalVat     = "total_vat"
        case totalWithVat = "total_with_vat"
    }


    func calculateTotal() -> Double {
        let sum = (items ?? []).reduce(0.0) { partial, item in
            partial + item.effectiveQuantity * item.unitPriceWithVat
        }
        return (sum * 100).rounded() / 100
    }
}

struct MessageResponse: Codable {
    var message: String?
}

struct ClientData: Codable {
    var id: Int?
    var customer: CustomerData?
}

struct BranchData: Codable {
    var id: String?
    var name: String?
}

struct ItemData: Codable, Identifiable {
    var id: String?
    var product_name: String?
    var product_id: Int?
    var price: Double?
    var vat_sum: Double?
    var quantity: Double?
    var mark_quantity: Double?
    var total_price: Double?
    var total_with_vat: Double?
    var has_marking: Bool?
    var units: [BasketItemUnit]?

    /// Bittalik narx + bittalik QQS (Android `unitPriceWithVat = unitPrice + unitVat`).
    var unitPriceWithVat: Double {
        (price ?? 0) + (vat_sum ?? 0)
    }

    /// Markirofkali tovarda skanerlangan son (mark_quantity), aks holda oddiy quantity
    /// (Android `calculateTotal` mantiqi).
    var effectiveQuantity: Double {
        if has_marking == true {
            return mark_quantity ?? 0
        }
        return quantity ?? 0
    }
}

struct BasketItemUnit: Codable {
    var id: Int?
    var product_unit_id: Int?
    var unit: String?
    var quantity: Double?
}
