import Swinject

final class NetworkAssembly: Assembly {

    func assemble(container: Container) {
        container.register(AuthService.self) { _ in AuthService() }
            .inObjectScope(.container)

        container.register(DashboardService.self) { _ in DashboardService() }
            .inObjectScope(.container)

        container.register(PartnerService.self) { _ in PartnerService() }
            .inObjectScope(.container)

        container.register(DealService.self) { _ in DealService() }
            .inObjectScope(.container)

        container.register(PaymentService.self) { _ in PaymentService() }
            .inObjectScope(.container)

        container.register(DocumentService.self) { _ in DocumentService() }
            .inObjectScope(.container)
    }
}
