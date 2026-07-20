internal import Foundation

struct ProductService: BaseService {
    typealias Convertible = ProductRouter
    
    func getProducts(completion: @escaping Completion<[ProductResponse]>){
        request(.getProducts, completion: completion)
    }
    
}
