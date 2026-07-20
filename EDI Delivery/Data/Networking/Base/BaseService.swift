import Alamofire
internal import Foundation

protocol BaseService {
    associatedtype Convertible: URLRequestConvertible
    typealias Completion<T> = (Result<T, NetworkError>) -> Void
    func request<T: Codable>(_ convertible: Convertible, completion: @escaping Completion<T>)
}

extension BaseService {
    func request<T: Codable>(_ convertible: Convertible, completion: @escaping Completion<T>) {
        AF.request(convertible).responseData(queue: .global(qos: .background)) { response in
            AnalysisResponseMonitor<T>(response: response).monitor(completion: completion)
        }
    }
}
