public import Foundation

public enum NetworkError: Swift.Error, LocalizedError {
    
    case standard(title: String, description: String)
    case technical(title: String, description: String)
    case unexpected(description: String)
    case unableToConnect
    case unauthorized
    
    public var errorDescription: String? {
        switch self {
        case .standard(let title, let description):
            return "\(title): \(description)"
        case .technical(let title, let description):
            return "\(title)\n\(description)"
        case .unexpected(let description):
            return description
        case .unableToConnect:
            return LanguageManager.shared[.error_no_internet]
        case .unauthorized:
            return LanguageManager.shared[.error_session_expired]
        }
    }
    
    public var message: String? {
        switch self {
        case .standard(_, let description),
             .technical(_, let description),
             .unexpected(let description):
            return description
        case .unableToConnect, .unauthorized:
            return self.errorDescription
        }
    }
    
}
