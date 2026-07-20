internal import Foundation

struct OrderService: BaseService {
    typealias Convertible = OrderRouter

    func getOrders(model: OrderRequest, completion: @escaping Completion<[OrderResponse]>) {
        request(.getOrders(model: model), completion: completion)
    }

    func getOrderDetail(id: String, completion: @escaping Completion<OrderDetailResponse>) {
        request(.getOrderDetail(id: id), completion: completion)
    }

    func cancelOrder(id: String, reason: String, completion: @escaping Completion<EmptyResponse>) {
        request(.cancelOrder(id: id, model: OrderCancelRequest(description: reason)), completion: completion)
    }

    func restoreOrder(id: String, reason: String, completion: @escaping Completion<EmptyResponse>) {
        request(.restoreOrder(id: id, model: OrderCancelRequest(description: reason)), completion: completion)
    }

    func getDeliveryDocument(id: String, completion: @escaping Completion<OrderDeliveryIdResponse>) {
        request(.getDeliveryDocument(id: id), completion: completion)
    }
}
