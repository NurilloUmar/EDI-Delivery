internal import Foundation
import Alamofire

enum BranchRouter: BaseURLRequestConvertible {

    case getBranches
    case getRegions
    case getDistricts(regionCode: Int)
    case getClients
    case registerClient(model: ClientRegisterRequest)
    case registerBranch(model: BranchRegisterRequest)
    case updateBranch(id: String, model: BranchUpdateRequest)

    var path: String {
        switch self {
        case .getBranches:             return "/api/mobile-api/delivery/v1/client-branch/get"
        case .getRegions:              return "/api/mobile-api/delivery/v1/common/get-regions"
        case .getDistricts(let code):  return "/api/mobile-api/delivery/v1/common/get-districts/\(code)"
        case .getClients:              return "/api/mobile-api/delivery/v1/client/get"
        case .registerClient:          return "/api/mobile-api/delivery/v1/client/register"
        case .registerBranch:          return "/api/mobile-api/delivery/v1/client-branch/register"
        case .updateBranch(let id, _): return "/api/mobile-api/delivery/v1/client-branch/update/\(id)"
        }
    }

    var method: Alamofire.HTTPMethod {
        switch self {
        case .getBranches, .getRegions, .getDistricts, .getClients: return .get
        case .registerClient, .registerBranch, .updateBranch:       return .post
        }
    }

    var parameters: Alamofire.Parameters? {
        switch self {
        case .getBranches, .getRegions, .getDistricts, .getClients: return nil
        case .registerClient(let m):   return m.dictionary
        case .registerBranch(let m):   return m.dictionary
        case .updateBranch(_, let m):  return m.dictionary
        }
    }
}
