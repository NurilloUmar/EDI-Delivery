internal import Foundation

struct ClientRegisterRequest: Codable {
    var username: String
    var name: String
    var code: String
    var customer_identifier: String?
    var is_verified: Bool = true
    var branch: BranchInfoPayload
}

struct BranchRegisterRequest: Codable {
    var client_id: Int?
    var code: String
    var name: String
    var region_code: Int?
    var district_code: Int?
    var street: String?
}

struct BranchUpdateRequest: Codable {
    var client_id: Int?
    var code: String
    var name: String
    var region_code: Int?
    var district_code: Int?
    var street: String?
}

struct BranchInfoPayload: Codable {
    var code: String
    var name: String
    var region_code: Int?
    var district_code: Int?
    var street: String?
}
