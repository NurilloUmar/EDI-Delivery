internal import Foundation

struct Header {

    enum Key: Hashable {
        case contentType
        case accept
        case authorization
        case accessToken
        case language
        case macAddress
        case custom(key: String)
        
        var key: String {
            switch self {
            case .contentType: return "Content-Type"
            case .accept: return "Accept"
            case .authorization: return "Authorization"
            case .accessToken: return "access_token"
            case .language: return "Accept-Language"
            case .macAddress: return "mac_address"
            case .custom(let key): return key
            }
        }
    }
    
}

extension Header {
    enum Value {
        case applicationJSON
        case applicationFormURLEncoded 
        case multipartFormData
        case language
        case custom(value: String)
        case smsToken
        case token
        
        var value: String {
            switch self {
            case .applicationJSON:
                return "application/json"
            case .applicationFormURLEncoded:
                return "application/x-www-form-urlencoded"
            case .multipartFormData:
                return "multipart/form-data; boundary=Boundary-\(UUID().uuidString)"
            case .language:
                return "uz"
            case .custom(let value):
                return value
            case .smsToken:
                return ""
            case .token:
                return Cache.share.getUserToken() ?? ""
            }
        }
    }
    
}
