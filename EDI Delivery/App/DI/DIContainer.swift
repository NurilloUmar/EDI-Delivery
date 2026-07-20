import Swinject

final class DIContainer {

    static let shared = DIContainer()

    private let assembler: Assembler

    private init() {
        assembler = Assembler([
            NetworkAssembly()
        ])
    }
    var resolver: Resolver { assembler.resolver }
}

extension Resolver {
    func get<Service>(_ type: Service.Type = Service.self) -> Service {
        guard let value = resolve(type) else {
            fatalError("Dependency \(type) not registered in DIContainer")
        }
        return value
    }
}
