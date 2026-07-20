internal import Foundation

struct NetworkDecoder<T: Decodable> {
    
    enum DecodeError: Swift.Error, LocalizedError {
        case dataNotFound
        case unableToDecode(description: String)
        case unableToConvertData(description: String)
        
        var errorDescription: String? {
            switch self {
            case .dataNotFound:
                return "Serverdan ma'lumot topilmadi (Data not found)."
            case .unableToDecode(let desc):
                return "Ma'lumotni o'qishda xatolik (Decoding error): \(desc)"
            case .unableToConvertData(let desc):
                return "Lug'atni formatlashda xatolik: \(desc)"
            }
        }
    }
    
    private let decoder = JSONDecoder()
    
    func decode(from data: Data?) throws -> T {
        guard let data = data else {
            throw DecodeError.dataNotFound
        }
        
        do {
            return try decoder.decode(T.self, from: data)
        } catch {
            throw DecodeError.unableToDecode(description: error.localizedDescription)
        }
    }
    
    func decode(from dictionary: [String: Any]) throws -> T {
        do {
            let data = try JSONSerialization.data(withJSONObject: dictionary, options: [])
            return try decode(from: data) 
        } catch {
            throw DecodeError.unableToConvertData(description: error.localizedDescription)
        }
    }
}
