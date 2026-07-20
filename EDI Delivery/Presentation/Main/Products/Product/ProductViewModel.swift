import UIKit
internal import Combine

enum ProductEvent {
    case viewDidLoad
    case refresh
    case refreshBasket
    case didTapDetail(ProductResponse)
    case didTapAddToBasket(ProductResponse)
    case dismissDetail
    case dismissBasket
    case confirmAddToBasket(productId: Int, price: Double, units: [BasketUnitPayload])
}

class ProductViewModel: ObservableObject {

    private let productService: ProductService
    private let basketService: BasketService
    private let navigation: ProductNavigation

    @Published var item: ProductUIState

    var filteredProducts: [ProductResponse] {
        guard !item.searchText.isEmpty else { return item.items }
        return item.items.filter {
            ($0.name ?? "").localizedCaseInsensitiveContains(item.searchText) ||
            ($0.barcode ?? "").localizedCaseInsensitiveContains(item.searchText)
        }
    }

    init(navigation: ProductNavigation, productService: ProductService, basketService: BasketService) {
        self.item = .init()
        self.navigation = navigation
        self.productService = productService
        self.basketService = basketService
    }

    func isInBasket(productId: Int?) -> Bool {
        guard let productId, let items = item.storedBasket?.items else { return false }
        return items.contains { $0.product_id == productId }
    }

    @MainActor
    func handleEvent(eventType: ProductEvent) {
        switch eventType {
        case .viewDidLoad, .refresh:
            fetchProducts()
            fetchStoredBasket()
        case .refreshBasket:
            fetchStoredBasket()
        case .didTapDetail(let product):
            item.detailProduct = product
        case .didTapAddToBasket(let product):
            item.basketProduct = product
        case .dismissDetail:
            item.detailProduct = nil
        case .dismissBasket:
            item.basketProduct = nil
        case .confirmAddToBasket(let productId, let price, let units):
            registerOrAdd(productId: productId, price: price, units: units)
        }
    }

    private func fetchProducts() {
        Loader.start()
        productService.getProducts { [weak self] result in
            guard let self else { return }
            DispatchQueue.main.async {
                Loader.stop()
                switch result {
                case .success(let products):
                    self.item.items = products
                case .failure:
                    break
                }
            }
        }
    }

    private func fetchStoredBasket() {
        basketService.getBaskets { [weak self] result in
            guard let self else { return }
            DispatchQueue.main.async {
                if case .success(let basket) = result {
                    self.item.storedBasket = basket
                }
            }
        }
    }

    private func registerOrAdd(productId: Int, price: Double, units: [BasketUnitPayload]) {
        guard !units.isEmpty else {
            Alert.showAlert(forState: .warning, message: L(.enterQuantity), vibrationType: .warning)
            return
        }

        item.isSubmitting = true
        Loader.start()
        let payload = BasketItemPayload(product_id: productId, price: price, units: units)

        if let basket = item.storedBasket, let basketId = basket.id {
            basketService.addItem(model: BasketAddItemRequest(basket_id: basketId, item: payload)) { [weak self] result in
                self?.handleBasketResult(result: result)
            }
        } else {
            basketService.registerBasket(model: BasketRegisterRequest(delivery_order_id: nil, client_branch_id: nil, items: [payload])) { [weak self] result in
                self?.handleBasketResult(result: result)
            }
        }
    }

    private func handleBasketResult(result: Result<BasketResponse, NetworkError>) {
        DispatchQueue.main.async {
            Loader.stop()
            self.item.isSubmitting = false
            switch result {
            case .success(let basket):
                self.item.storedBasket = basket
                self.item.basketProduct = nil
                Alert.showAlert(forState: .success, message: L(.addedToBasket), vibrationType: .success)
            case .failure:
                break
            }
        }
    }
}
