internal import Foundation
import Alamofire

enum BasketRouter: BaseURLRequestConvertible {

    case getBaskets
    case registerBasket(model: BasketRegisterRequest)
    case approve(model: BasketApproveRequest)
    case clearBasket(model: BasketClearRequest)
    case deleteItem(model: BasketDeleteItemRequest)
    case addItem(model: BasketAddItemRequest)
    case updateItem(model: BasketUpdateItemRequest)
    case updateClient(model: BasketUpdateClientRequest)

    var path: String {
        switch self {
        case .getBaskets:      return "/api/mobile-api/delivery/v1/basket/get"
        case .registerBasket:  return "/api/mobile-api/delivery/v1/basket/register"
        case .approve:         return "/api/mobile-api/delivery/v1/basket/approve"
        case .clearBasket:     return "/api/mobile-api/delivery/v1/basket/clear"
        case .deleteItem:      return "/api/mobile-api/delivery/v1/basket/delete-item"
        case .addItem:         return "/api/mobile-api/delivery/v1/basket/add-item"
        case .updateItem:      return "/api/mobile-api/delivery/v1/basket/update-item"
        case .updateClient:    return "/api/mobile-api/delivery/v1/basket/update-client"
        }
    }

    var method: Alamofire.HTTPMethod {
        switch self {
        case .getBaskets: return .get
        default:          return .post
        }
    }

    var parameters: Alamofire.Parameters? {
        switch self {
        case .getBaskets:                return nil
        case .registerBasket(let m):     return m.dictionary
        case .approve(let m):            return m.dictionary
        case .clearBasket(let m):        return m.dictionary
        case .deleteItem(let m):         return m.dictionary
        case .addItem(let m):            return m.dictionary
        case .updateItem(let m):         return m.dictionary
        case .updateClient(let m):       return m.dictionary
        }
    }
}
