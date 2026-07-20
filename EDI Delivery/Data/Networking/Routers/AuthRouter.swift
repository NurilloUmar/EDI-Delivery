internal import Foundation
import Alamofire

enum LoginRouter: BaseURLRequestConvertible {
    
    case login(model: LoginRequest)
    case getMe
    case logOut
   
    var path: String {
        switch self {
        case .login:
            return "/api/auth/login"
        case .getMe:
            return "/api/auth/get-me"
        case .logOut:
            return "/api/auth/logout"
        }
    }
    
    var method: Alamofire.HTTPMethod {
        switch self {
        case .login:
            return .post
        case .getMe, .logOut:
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
