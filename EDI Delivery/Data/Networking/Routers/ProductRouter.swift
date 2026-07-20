internal import Foundation
import Alamofire

enum ProductRouter: BaseURLRequestConvertible {
    
    case getProducts
   
    var path: String {
        switch self {
        case .getProducts:
            return "/api/mobile-api/delivery/v1/product/get"
        }
    }
    
    var method: Alamofire.HTTPMethod {
        switch self {
        case .getProducts:
            return .get
        }
    }
    
    var parameters: Alamofire.Parameters? {
        switch self {
        case .getProducts:
            return nil
        }
    }
    
}
