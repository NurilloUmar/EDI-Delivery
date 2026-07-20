internal import Foundation

struct BranchService: BaseService {
    typealias Convertible = BranchRouter

    func getBranches(completion: @escaping Completion<[BranchResponse]>) {
        request(.getBranches, completion: completion)
    }

    func getRegions(completion: @escaping Completion<[RegionResponse]>) {
        request(.getRegions, completion: completion)
    }

    func getDistricts(regionCode: Int, completion: @escaping Completion<[DistrictResponse]>) {
        request(.getDistricts(regionCode: regionCode), completion: completion)
    }

    func getClients(completion: @escaping Completion<[ClientResponse]>) {
        request(.getClients, completion: completion)
    }

    func registerClient(model: ClientRegisterRequest, completion: @escaping Completion<EmptyResponse>) {
        request(.registerClient(model: model), completion: completion)
    }

    func registerBranch(model: BranchRegisterRequest, completion: @escaping Completion<EmptyResponse>) {
        request(.registerBranch(model: model), completion: completion)
    }

    func updateBranch(id: String, model: BranchUpdateRequest, completion: @escaping Completion<BranchResponse>) {
        request(.updateBranch(id: id, model: model), completion: completion)
    }
}
