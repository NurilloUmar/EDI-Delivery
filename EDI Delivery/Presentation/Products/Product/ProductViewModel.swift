import UIKit
internal import Combine

enum ProductEvent {
    case viewDidLoad
    case refresh
}

class ProductViewModel: ObservableObject {

    private let productService: ProductService
    private let navigation: ProductNavigation

    @Published var item: ProductUIState

    init(navigation: ProductNavigation, productService: ProductService) {
        self.item = .init()
        self.navigation = navigation
        self.productService = productService
    }

    @MainActor
    func handleEvent(eventType: ProductEvent) {
        switch eventType {
        case .viewDidLoad, .refresh:
            fetchProducts()
        }
    }

    private func fetchProducts() {
        Loader.start()
        
        productService.getProducts { [weak self] result in
            guard let self else { return }
            
            // UI bilan bog'liq har qanday o'zgarishni Main Thread'ga olamiz!
            DispatchQueue.main.async {
                Loader.stop()
                
                switch result {
                case .success(let products):
                    // Mana endi SwiftUI xotirada adashmaydi va o'zining unikal ID'si bilan toza chizadi
                    self.item.items = products
                    print("\(products.count) ✅✅✅✅✅")

                case .failure(let error):
                    print(error.localizedDescription)
                    Alert.showAlert(forState: .error, message: error.localizedDescription, vibrationType: .error)
                }
            }
        }
    }
}
