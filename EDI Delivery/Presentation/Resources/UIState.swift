internal import Foundation

enum UIState<T> {
    case isLoading
    case success(T)
    case error(ErrorData)
}
