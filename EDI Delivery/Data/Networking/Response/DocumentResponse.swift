internal import Foundation

struct DocumentResponse: Codable, Identifiable {
    var id: String?
    var number: String?
    var date: String?
    var contractNumber: String?
    var invoiceId: String?
    var clientBranch: ClientBranch?
    var totalPrice: Double?
    var totalVat: Double?
    var totalWithVat: Double?
    var ofdCheques: [OfdCheque]?
    var items: [DocumentItemResponse]?

    enum CodingKeys: String, CodingKey {
        case id, number, date, items
        case contractNumber = "contract_number"
        case invoiceId      = "invoice_id"
        case clientBranch   = "client_branch"
        case totalPrice     = "total_price"
        case totalVat       = "total_vat"
        case totalWithVat   = "total_with_vat"
        case ofdCheques     = "ofd_cheques"
    }
}

struct DocumentItemResponse: Codable, Identifiable {
    var id: String?
    var productName: String?
    var barcode: String?
    var measurement: String?
    var vatRate: Double?
    var price: Double?
    var quantity: Double?
    var totalPrice: Double?
    var totalWithVat: Double?

    enum CodingKeys: String, CodingKey {
        case id, barcode, measurement, price, quantity
        case productName  = "product_name"
        case vatRate      = "vat_rate"
        case totalPrice   = "total_price"
        case totalWithVat = "total_with_vat"
    }

    /// Birlik narxi QQS bilan — server alohida yubormaydi, jami QQS'li
    /// summadan hisoblaymiz (totalWithVat / quantity); bo'lmasa price'ga qaytamiz.
    var priceWithVat: Double {
        if let totalWithVat, let quantity, quantity > 0 {
            return totalWithVat / quantity
        }
        return price ?? 0
    }
}

struct OfdCheque: Codable {
    var url: String?
}
