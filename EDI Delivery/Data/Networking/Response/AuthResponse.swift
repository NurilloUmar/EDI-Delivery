
struct LoginResponse: Codable {
    var token: String?
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.token = try container.decodeIfPresent(String.self, forKey: .token)
    }
}

struct EmptyResponse: Codable {}


struct GetMeResponse: Codable {

    var data: UserData?
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        data = try? container.decode(UserData.self, forKey: .data)
    }
    
    enum CodingKeys: String, CodingKey {
        case data
    }
    
}

struct UserData: Codable{
    var id: Int?
    var created_at: String?
    var is_deactivated: Bool?
    var deactivated_at: String?
    var identifier: String?
    var username: String?
    var name: String?
    var code: String?
    var car_mark: String?
    var car_serial_number: String?
    var other_car_owner_identifier: String?
    var other_car_owner_name: String?
    var organization: OrganizationData?
    var organization_settings: OrganizationDataSettings?
    
}

struct OrganizationData: Codable{
    var name: String?
    var inn: String?
    var pinfl: String?
}

struct OrganizationDataSettings: Codable{
    var using_bill_to_ship_order: Bool?
    var using_delivery_document_without_order: Bool?
    var using_always_basket_closing_type: Bool?
}
