

enum Domain {
    case base
    var string: String {
        switch self {
        case .base:
            return "https://staging-edi.hippo.uz"
        }
    }
}
