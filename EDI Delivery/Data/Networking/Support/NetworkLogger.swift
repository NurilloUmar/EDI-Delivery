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

            // Yuborilgan parametrlar (request body)
            logData(bodyData(from: request), title: "📤 Request Body")

            if let response = task.response {
                logHeaders(title: "Response Headers", headers: response.allHeaderFields)
            }

            if let error = task.error {
                print("❌ Error: \(error.localizedDescription)")
            }

            logData(task.data, title: "📥 Response Body")
            logDivider()
        }
        #endif
    }
    
    private static func logData(_ data: Data?, title: String) {
        guard let data = data, !data.isEmpty else { return }
        do {
            let jsonObject = try JSONSerialization.jsonObject(with: data, options: .mutableContainers)
            let prettyData = try JSONSerialization.data(withJSONObject: jsonObject, options: [.prettyPrinted, .sortedKeys])
            if let prettyPrintedString = String(data: prettyData, encoding: .utf8) {
                print("\(title):\n\(prettyPrintedString)\n")
            }
        } catch {
            if let string = String(data: data, encoding: .utf8) {
                print("\(title) (text): \(string)\n")
            }
        }
    }

    /// Alamofire request body'ni oladi. JSONEncoding POST/PUT uchun `httpBody`da bo'ladi;
    /// ba'zi hollarda stream orqali yuboriladi — o'shani ham o'qiymiz.
    private static func bodyData(from request: URLRequest) -> Data? {
        if let body = request.httpBody { return body }
        guard let stream = request.httpBodyStream else { return nil }
        stream.open()
        defer { stream.close() }
        var data = Data()
        let bufferSize = 1024
        let buffer = UnsafeMutablePointer<UInt8>.allocate(capacity: bufferSize)
        defer { buffer.deallocate() }
        while stream.hasBytesAvailable {
            let read = stream.read(buffer, maxLength: bufferSize)
            if read <= 0 { break }
            data.append(buffer, count: read)
        }
        return data.isEmpty ? nil : data
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
        // Data bo'lmasa ham callback chaqirilishi SHART — aks holda xato "jim" yutiladi
        // (na Alert chiqadi, na ViewModel'ga natija qaytadi).
        guard let responseData = data else {
            completion("", -1)
            return
        }
        do {
            let json = JSON(try JSONSerialization.jsonObject(with: responseData, options: []))
            completion(json["result_msg"].stringValue, json["result_code"].intValue)
        } catch {
            completion(String(data: responseData, encoding: .utf8) ?? "", -1)
        }
    }
}
