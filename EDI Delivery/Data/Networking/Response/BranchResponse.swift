internal import Foundation

struct BranchResponse: Codable, Identifiable {
    var id: String?
    var code: String?
    var name: String?
    var street: String?
    var region: RegionData?
    var district: RegionData?
    var customer: CustomerData?
    var clientInfo: ClientInfoData?

    enum CodingKeys: String, CodingKey {
        case id, code, name, street, region, district, customer
        case clientInfo = "client_info"
    }
}

struct RegionData: Codable {
    var code: Int?
    var name: String?
}

struct CustomerData: Codable {
    var id: Int?
    var identifier: String?
    var name: String?
}

struct ClientInfoData: Codable {
    var id: Int?
    var name: String?
    var username: String?
}

struct RegionResponse: Codable, Identifiable {
    var id: UUID = UUID()
    var code: Int?
    var name: String?

    enum CodingKeys: String, CodingKey {
        case code, name
    }
}

struct DistrictResponse: Codable, Identifiable {
    var id: UUID = UUID()
    var code: Int?
    var name: String?
    var regionCode: Int?

    enum CodingKeys: String, CodingKey {
        case code, name
        case regionCode = "region_code"
    }
}

struct ClientResponse: Codable, Identifiable {
    var id: Int?
    var name: String?
    var username: String?
    var customer: CustomerData?

    enum CodingKeys: String, CodingKey {
        case id, name, username, customer
    }
}
