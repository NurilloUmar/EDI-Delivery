internal import Foundation
import Alamofire

enum DocumentRouter: BaseURLRequestConvertible {

    case getDocuments(model: DocumentRequest)
    case getDocument(id: String)

    var path: String {
        switch self {
        case .getDocuments:          return "/api/mobile-api/delivery/v1/get-delivery-documents"
        case .getDocument(let id):   return "/api/mobile-api/delivery/v1/get-delivery-document/\(id)"
        }
    }

    var method: Alamofire.HTTPMethod {
        switch self {
        case .getDocuments, .getDocument: return .get
        }
    }

    var parameters: Alamofire.Parameters? {
        switch self {
        case .getDocuments(let m): return m.dictionary
        case .getDocument:         return nil
        }
    }
}
