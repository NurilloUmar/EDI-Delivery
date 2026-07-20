internal import Foundation

struct ProductUIState {
    var items: [ProductResponse] = []
    var searchText: String = ""

    var detailProduct: ProductResponse?
    var basketProduct: ProductResponse?
    var storedBasket: BasketResponse?
    var isSubmitting: Bool = false
}
