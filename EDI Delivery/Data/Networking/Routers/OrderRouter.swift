internal import Foundation
import Alamofire

enum OrderRouter: BaseURLRequestConvertible {

    case getOrders(model: OrderRequest)
    case getOrderDetail(id: String)
    case cancelOrder(id: String, model: OrderCancelRequest)
    case restoreOrder(id: String, model: OrderCancelRequest)
    case getDeliveryDocument(id: String)

    var path: String {
        switch self {
        case .getOrders:
            return "/api/mobile-api/delivery/v1/get-delivery-orders"
        case .getOrderDetail(let id):
            return "/api/mobile-api/delivery/v1/get-delivery-order/\(id)"
        case .cancelOrder(let id, _):
            return "/api/mobile-api/delivery/v1/cancel-delivery-order/\(id)"
        case .restoreOrder(let id, _):
            return "/api/mobile-api/delivery/v1/restore-delivery-order/\(id)"
        case .getDeliveryDocument(let id):
            return "/api/mobile-api/delivery/v1/get-delivery-document/\(id)"
        }
    }

    var method: Alamofire.HTTPMethod {
        switch self {
        case .getOrders, .getOrderDetail, .getDeliveryDocument:
            return .get
        case .cancelOrder, .restoreOrder:
            return .post
        }
    }

    var parameters: Alamofire.Parameters? {
        switch self {
        case .getOrders(let model):
            return model.dictionary
        case .cancelOrder(_, let model):
            return model.dictionary
        case .restoreOrder(_, let model):
            return model.dictionary
        case .getOrderDetail, .getDeliveryDocument:
            return nil
        }
    }
}
