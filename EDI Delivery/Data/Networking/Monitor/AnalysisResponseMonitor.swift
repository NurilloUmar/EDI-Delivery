import Alamofire
import UIKit
import SwiftyJSON
internal import Foundation

struct AnalysisResponseMonitor<T> where T: Codable {
    
    private let response: DataResponse<Data, AFError>
    
    public init(response: DataResponse<Data, AFError>) {
        self.response = response
    }
    
    internal func monitor(completion: @escaping (Result<T, NetworkError>) -> Void) {
        do {
            let statusCode = try inspectStatusCode()
            
            NetworkLogger.log(response)
            
            if statusCode >= 200 && statusCode < 300 {
                try inspectResult(completion: completion)
            } else if statusCode == 502 {
                // Yagona catch tarmog'iga tushadi: Alert ham chiqadi, completion ham
                // chaqiriladi (avval completion chaqirilmay, ekran state'i osilib qolardi).
                throw NetworkError.unexpected(description: L(.serverError))
            } else {
                // Backend xato xabarini "message" yoki "error" kalitida yuborishi mumkin.
                // Ikkalasi ham bo'sh bo'lsa — status kodga qarab tushunarli xabar beramiz.
                let json: JSON = response.data.flatMap { try? JSON(data: $0) } ?? JSON.null
                let serverMessage = json["message"].string?.nonEmpty
                    ?? json["error"].string?.nonEmpty
                let message = serverMessage ?? fallbackMessage(for: statusCode)
                throw NetworkError.unexpected(description: message)
            }
        } catch {
            let finalError = (error as? NetworkError) ?? .technical(title: L(.dataError), description: error.localizedDescription)
            // Xato xabari BITTA markaziy joyda ko'rsatiladi: har bir response shu
            // monitor'dan o'tadi, shuning uchun hech bir xato Alert'siz qolmaydi.
            // ViewModel'lar failure'da faqat o'z state'ini tozalaydi.
            DispatchQueue.main.async {
                Loader.stop()
                Alert.showAlert(
                    forState: .error,
                    message: finalError.message ?? finalError.localizedDescription,
                    vibrationType: .error
                )
                completion(.failure(finalError))
            }
        }
    }
    
    private func inspectResult(completion: @escaping (Result<T, NetworkError>) -> Void) throws {
        switch response.result {
        case .success:
            if response.data == nil || response.data?.isEmpty == true,
               let empty = EmptyResponse() as? T {
                DispatchQueue.main.async { completion(.success(empty)) }
                return
            }

            let model = try NetworkDecoder<T>().decode(from: response.data)
            DispatchQueue.main.async { completion(.success(model)) }

        case .failure(let error):
            if response.data == nil || response.data?.isEmpty == true,
               let empty = EmptyResponse() as? T {
                DispatchQueue.main.async { completion(.success(empty)) }
                return
            }

            // Callback sinxron ishlaydi — xabarni yig'ib, xatoni yagona catch
            // tarmog'iga (Loader.stop + Alert + completion) uzatamiz.
            var serverMessage = ""
            NetworkLogger.responseErrorMessage(response.data) { errorMsg, _ in
                serverMessage = errorMsg
            }
            throw NetworkError.unexpected(description: serverMessage.nonEmpty ?? error.localizedDescription)
        }
    }
    
    private func fallbackMessage(for statusCode: Int) -> String {
        switch statusCode {
        case 409: return L(.alreadyExists)
        default:  return L(.requestFailed)
        }
    }

    private func inspectStatusCode() throws -> Int {
        guard let statusCode = response.response?.statusCode else {
            throw NetworkError.unableToConnect
        }

        // 401 faqat mavjud sessiya eskirganda majburiy logout qiladi.
        // Login paytida token hali yo'q — u holda 401 "login/parol xato" degani:
        // pastdagi umumiy xato tarmog'iga tushadi (server xabari alert'da chiqadi),
        // ekran qayta qurilmaydi va kiritilgan raqam saqlanib qoladi.
        if statusCode == 401, Cache.share.getUserToken() != nil {
            DispatchQueue.main.async {
                Loader.stop()
                Cache.share.deleteUserToken()
                AuthSession.delegate?.routeToAuth()
            }
            throw NetworkError.unauthorized
        }

        return statusCode
    }
}

private extension String {
    /// Bo'sh (yoki faqat bo'shliqdan iborat) satrni `nil` qaytaradi.
    var nonEmpty: String? {
        let trimmed = trimmingCharacters(in: .whitespacesAndNewlines)
        return trimmed.isEmpty ? nil : trimmed
    }
}
