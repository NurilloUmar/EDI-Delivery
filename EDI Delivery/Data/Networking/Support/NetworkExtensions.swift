

internal import Foundation

extension URLRequest {

    mutating func add(key: Header.Key, value: Header.Value) {
        let raw = value.value
        if key.key == Header.Key.authorization.key, raw.isEmpty { return }
        setValue(raw, forHTTPHeaderField: key.key)
    }

    mutating func add(contentOf headers: [Header.Key: Header.Value]) {
        headers.forEach { add(key: $0.key, value: $0.value) }
    }
}
