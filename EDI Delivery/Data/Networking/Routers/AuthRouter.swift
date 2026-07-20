internal import Foundation
import Alamofire

enum LoginRouter: BaseURLRequestConvertible {
    
    case login(model: LoginRequest)
    case getMe
    case logOut
   
    var path: String {
        switch self {
        case .login:
            return "/api/mobile-api/courier/login"
        case .getMe:
            return "/api/mobile-api/delivery/v1/common/get-me"
        case .logOut:
            return "/api/mobile-api/delivery/v1/auth/logout"
        }
    }
    
    var method: Alamofire.HTTPMethod {
        switch self {
        case .login, .logOut:
            return .post
        case .getMe:
            return .get
        }
    }
    
    var parameters: Alamofire.Parameters? {
        switch self {
        case .login(let model):
            let params = model.dictionary
            return params
        case .getMe, .logOut:
            return nil
        }
    }
    
}
