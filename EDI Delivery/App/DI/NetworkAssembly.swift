import Swinject

final class NetworkAssembly: Assembly {

    func assemble(container: Container) {
        container.register(AuthService.self) { _ in AuthService() }
            .inObjectScope(.container)

        container.register(ProductService.self) { _ in ProductService() }
            .inObjectScope(.container)
        
        container.register(BranchService.self) { _ in BranchService() }
            .inObjectScope(.container)
        
        
        container.register(OrderService.self) { _ in OrderService() }
            .inObjectScope(.container)

        container.register(BasketService.self) { _ in BasketService() }
            .inObjectScope(.container)
        
        
        container.register(DocumentService.self) { _ in DocumentService() }
            .inObjectScope(.container)
//
//        container.register(DealService.self) { _ in DealService() }
//            .inObjectScope(.container)
//
//        container.register(PaymentService.self) { _ in PaymentService() }
//            .inObjectScope(.container)
//
//        container.register(DocumentService.self) { _ in DocumentService() }
//            .inObjectScope(.container)
    }
}
