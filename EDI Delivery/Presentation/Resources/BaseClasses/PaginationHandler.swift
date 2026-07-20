internal import Foundation

protocol PaginatedItemList {
    associatedtype Item
    var items: [Item] { get set }
    var isLoading: Bool { get set }
    var isLoadingMore: Bool { get set }
    var hasMore: Bool { get set }
    var skip: Int { get set }
    var limit: Int { get }
}

@MainActor
enum PaginationHandler {

    @discardableResult
    static func prepare<S: PaginatedItemList>(state: inout S, reset: Bool) -> Bool {
        if reset {
            state.skip = 0
            state.hasMore = true
            state.items = []
        }
        guard state.hasMore else { return false }
        if reset {
            state.isLoading = true
        } else {
            state.isLoadingMore = true
        }
        return true
    }

    static func apply<S: PaginatedItemList, R>(
        result: Result<R, NetworkError>,
        state: inout S,
        reset: Bool,
        extract: (R) -> [S.Item]
    ) {
        state.isLoading = false
        state.isLoadingMore = false

        switch result {
        case .success(let response):
            let newItems = extract(response)
            if reset {
                state.items = newItems
            } else {
                state.items.append(contentsOf: newItems)
            }
            state.hasMore = newItems.count >= state.limit
            state.skip += newItems.count

        case .failure(let error):
            Alert.showAlert(
                forState: .error,
                message: error.localizedDescription,
                vibrationType: .error
            )
        }
    }
}
