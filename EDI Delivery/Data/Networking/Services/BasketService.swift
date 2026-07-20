internal import Foundation
import Alamofire

struct BasketService: BaseService {
    typealias Convertible = BasketRouter

    func getBaskets(completion: @escaping Completion<BasketResponse?>) {
        AF.request(BasketRouter.getBaskets).responseData(queue: .global(qos: .background)) { response in
            if response.response?.statusCode == 404 {
                DispatchQueue.main.async { completion(.success(nil)) }
                return
            }
            AnalysisResponseMonitor<BasketResponse?>(response: response).monitor(completion: completion)
        }
    }

    func registerBasket(model: BasketRegisterRequest, completion: @escaping Completion<BasketResponse>) {
        request(.registerBasket(model: model), completion: completion)
    }

    func approve(model: BasketApproveRequest, completion: @escaping Completion<MessageResponse>) {
        request(.approve(model: model), completion: completion)
    }

    func clearBasket(basketId: String, completion: @escaping Completion<MessageResponse>) {
        request(.clearBasket(model: BasketClearRequest(basket_id: basketId)), completion: completion)
    }

    func deleteItem(basketId: String, itemId: String, completion: @escaping Completion<BasketResponse>) {
        request(.deleteItem(model: BasketDeleteItemRequest(basket_id: basketId, basket_item_id: itemId)), completion: completion)
    }

    func addItem(model: BasketAddItemRequest, completion: @escaping Completion<BasketResponse>) {
        request(.addItem(model: model), completion: completion)
    }

    func updateItem(model: BasketUpdateItemRequest, completion: @escaping Completion<BasketResponse>) {
        request(.updateItem(model: model), completion: completion)
    }

    func updateClient(basketId: String, clientId: Int?, branchId: String?, completion: @escaping Completion<BasketResponse>) {
        let model = BasketUpdateClientRequest(basket_id: basketId, client_id: clientId, client_branch_id: branchId)
        request(.updateClient(model: model), completion: completion)
    }
}
