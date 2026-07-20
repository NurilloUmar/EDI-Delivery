import UIKit
import Alamofire
import SwiftyJSON

internal final class NetworkLogger {
    
 
    static func log<Value>(_ task: DataResponse<Value, AFError>) {
        #if DEBUG
        guard let request = task.request else { return }
        
        DispatchQueue.global(qos: .background).async {
            let statusCode = task.response?.statusCode ?? 0
            let statusIcon = (200...299).contains(statusCode) ? "🟢" : "🔴"
            
            print("\n\(statusIcon) [StatusCode: \(statusCode)] | Method: \(request.httpMethod ?? "") | URL: \(request)\n")
            
            logHeaders(title: "Request Headers", headers: request.allHTTPHeaderFields)
            
            if let response = task.response {
                logHeaders(title: "Response Headers", headers: response.allHeaderFields)
            }
            
            if let error = task.error {
                print("❌ Error: \(error.localizedDescription)")
            }
            
            logData(task.data)
            logDivider()
        }
        #endif
    }
    
    private static func logData(_ data: Data?) {
        guard let data = data else { return }
        do {
            let jsonObject = try JSONSerialization.jsonObject(with: data, options: .mutableContainers)
            let prettyData = try JSONSerialization.data(withJSONObject: jsonObject, options: .prettyPrinted)
            if let prettyPrintedString = String(data: prettyData, encoding: .utf8) {
                print("📦 Body JSON:\n\(prettyPrintedString)")
            }
        } catch {
            if let string = String(data: data, encoding: .utf8) {
                print("📝 Body Text: \(string)")
            }
        }
    }
    
    private static func logDivider(header: String? = nil) {
        print("\n« ------------- « ----------------- « \(header ?? "END") » ------------- » ----------------- »\n")
    }
    
    private static func logHeaders(title: String = "", headers: [AnyHashable : Any]?) {
        guard let headers = headers, !headers.isEmpty else { return }
        print("📋 \(title): [")
        for (key, value) in headers {
            print("  \(key) : \(value)")
        }
        print("]\n")
    }
    
    public static func responseErrorMessage(_ data: Data?, completion: @escaping(String, Int) -> Void) {
        guard let responseData = data else { return }
        do {
            let json = JSON(try JSONSerialization.jsonObject(with: responseData, options: []))
            completion(json["result_msg"].stringValue, json["result_code"].intValue)
        } catch {
            if let string = String(data: responseData, encoding: .utf8) {
                completion(string, -1)
            }
        }
    }
}
