
struct LoginResponse: Codable {
    var success: Bool?
    var data: LoginData?
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        success = try? container.decode(Bool.self, forKey: .success)
        data = try? container.decode(LoginData.self, forKey: .data)
    }
    
    enum CodingKeys: String, CodingKey {
        case success, data
    }
    
}


struct LoginData: Codable{
    var token: String?
}
struct EmptyResponse: Codable {}


struct GetMeResponse: Codable {
    var success: Bool?
    var data: UserData?
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        success = try? container.decode(Bool.self, forKey: .success)
        data = try? container.decode(UserData.self, forKey: .data)
    }
    
    enum CodingKeys: String, CodingKey {
        case success, data
    }
    
}


struct UserData: Codable{
    var id: Int?
    var username: String?
    var fullName: String?
    var pinfl: String?
    var phoneNumber: String?
    var email: String?
}
