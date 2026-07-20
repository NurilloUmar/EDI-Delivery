import Alamofire
import UIKit
import SwiftyJSON
internal import Foundation

protocol BaseURLRequestConvertible: URLRequestConvertible {
    typealias Headers = [Header.Key: Header.Value]
    
    var path: String { get }
    var method: HTTPMethod { get }
    var parameters: Parameters? { get }
    var headers: Headers { get }
    var baseDomain: Domain { get }
}

extension BaseURLRequestConvertible {
    var baseDomain: Domain { .base }
    var headers: Headers { .defaultHeaders }
    
    func makeURL() throws -> URL {
        let trimmedPath = path.hasPrefix("/") ? String(path.dropFirst()) : path
        let fullPath = "\(baseDomain.string)/\(trimmedPath)"
        
        guard let url = URL(string: fullPath.encodeUrl) else {
            throw NetworkError.unexpected(description: "Noto'g'ri URL manzili: \(fullPath)")
        }
        return url
    }
    

    func asURLRequest() throws -> URLRequest {
        let url = try makeURL()
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        
        request.add(contentOf: headers)
        
        if let parameters = parameters {
            if method == .get {
                return try URLEncoding.default.encode(request, with: parameters)
            } else {
                return try JSONEncoding.default.encode(request, with: parameters)
            }
        }
        
        return request
    }
}

extension Dictionary where Key == Header.Key, Value == Header.Value {
    static var defaultHeaders: Self {
        [.accept: .applicationJSON,
         .contentType: .applicationJSON,
         .authorization: .token,
         .language: .language]
    }
}

extension Encodable {
    var dictionary: [String: Any]? {
        guard let data = try? JSONEncoder().encode(self) else { return nil }
        return (try? JSONSerialization.jsonObject(with: data, options: .allowFragments)).flatMap { $0 as? [String: Any] }
    }
}
