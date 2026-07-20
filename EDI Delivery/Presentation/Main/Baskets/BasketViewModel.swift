import UIKit
internal import Combine

enum BasketEvent {
    case viewDidLoad
    case refresh
    case approve
    case confirmApprove
    case confirmClosingType(Int)
    case clearBasket
    case confirmClear
    case deleteItem(id: String)
    case didTapItem(ItemData)
    case didTapViewItem(ItemData)
    case dismissItemDetail
    case dismissEdit
    case confirmEdit(itemId: String, price: Double, units: [BasketUnitPayload])
    case didTapAddProduct
    case didTapAddSalePoint
}

class BasketViewModel: ObservableObject {

    private let basketService: BasketService
    private let navigation: BasketNavigation

    @Published var item: BasketUIState

    init(navigation: BasketNavigation, basketService: BasketService) {
        self.item = .init()
        self.navigation = navigation
        self.basketService = basketService
    }

    @MainActor
    func handleEvent(eventType: BasketEvent) {
        switch eventType {
        case .viewDidLoad, .refresh:
            fetchBasket()
        case .approve:
            guard let basket = item.basket,
                  let items = basket.items, !items.isEmpty else {
                Alert.showAlert(forState: .warning, message: L(.noProductsInBasket), vibrationType: .warning)
                return
            }
            // Android bilan bir xil (SalesContentView): birorta itemda
            // mark_quantity != quantity bo'lsa — "roziman" checkbox'li tasdiqlash
            // sheet'i chiqadi; hammasi to'liq skanerlangan bo'lsa — sheet'siz
            // to'g'ridan-to'g'ri topshiriladi.
            let needsConfirmation = items.contains { ($0.mark_quantity ?? 0) != ($0.quantity ?? 0) }
            if needsConfirmation {
                item.isApproveConfirmed = false
                item.showApproveSheet = true
            } else {
                proceedToApprove()
            }
        case .confirmApprove:
            item.showApproveSheet = false
            proceedToApprove()
        case .confirmClosingType(let type):
            item.showClosingTypeSheet = false
            approveBasket(type: type)
        case .clearBasket:
            item.showClearAlert = true
        case .confirmClear:
            clearBasket()
        case .deleteItem(let id):
            deleteItem(id: id)
        case .didTapItem(let basketItem):
            item.editingItem = basketItem
        case .didTapViewItem(let basketItem):
            item.detailItem = basketItem
        case .dismissItemDetail:
            item.detailItem = nil
        case .dismissEdit:
            item.editingItem = nil
        case .confirmEdit(let itemId, let price, let units):
            updateItem(itemId: itemId, price: price, units: units)
        case .didTapAddProduct:
            navigation.routeToProduct()
        case .didTapAddSalePoint:
            navigation.routeToSalePoints()
        }
    }

    private func fetchBasket() {
        Loader.start()
        basketService.getBaskets { [weak self] result in
            DispatchQueue.main.async {
                Loader.stop()
                switch result {
                case .success(let basket):
                    self?.item.basket = basket
                case .failure:
                    break
                }
            }
        }
    }

    /// Android bilan bir xil (SalesScreenModelImpl.Approve): sozlamada
    /// "har doim sotuv turi so'ralsin" o'chiq bo'lsa VA savatda closingType bor
    /// bo'lsa — so'ramasdan topshiramiz; aks holda sotuv turini tanlash sheet'i chiqadi.
    private func proceedToApprove() {
        let alwaysAsk = Cache.share.getUser()?
            .organization_settings?.using_always_basket_closing_type ?? false
        if !alwaysAsk, let type = item.basket?.closingType {
            approveBasket(type: type)
        } else {
            // Approve sheet'i yopilib bo'lishini kutamiz — SwiftUI bir runloop'da
            // ikkita sheet'ni almashtira olmaydi.
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
                self?.item.showClosingTypeSheet = true
            }
        }
    }

    private func approveBasket(type: Int) {
        guard let basket = item.basket, let id = basket.id else { return }

        // Jami summani item'lardan hisoblaymiz (Android bilan bir xil) — server
        // qiymati emas, aks holda naqd/karta bo'linishi noto'g'ri ketadi.
        // Eslatma: Android'da "total > 0" tekshiruvi YO'Q — markirovkali itemlar
        // chala skanerlangan bo'lsa total 0 chiqadi va bu normal holat
        // ("roziman" checkbox'i aynan shuni tasdiqlaydi), topshirish bloklanmasligi kerak.
        let total = basket.calculateTotal()

        let cashValue: Double?
        let cardValue: Double?
        if type == 2 {
            let card = Double(item.card) ?? 0
            cashValue = max(total - card, 0)
            cardValue = card
        } else {
            cashValue = nil
            cardValue = nil
        }

        let model = BasketApproveRequest(
            basket_id: id,
            type: type,
            cash: cashValue,
            card: cardValue,
            version: 2
        )

        Loader.start()
        basketService.approve(model: model) { [weak self] result in
            DispatchQueue.main.async {
                Loader.stop()
                switch result {
                case .success:
                    self?.item = .init()
                    Alert.showAlert(forState: .success, message: L(.submittedSuccess), vibrationType: .success)
                case .failure:
                    break
                }
            }
        }
    }

    private func clearBasket() {
        guard let id = item.basket?.id else { return }
        Loader.start()
        basketService.clearBasket(basketId: id) { [weak self] result in
            DispatchQueue.main.async {
                Loader.stop()
                switch result {
                case .success:
                    self?.item = .init()
                case .failure:
                    break
                }
            }
        }
    }

    private func deleteItem(id: String) {
        guard let basketId = item.basket?.id else { return }
        Loader.start()
        basketService.deleteItem(basketId: basketId, itemId: id) { [weak self] result in
            DispatchQueue.main.async {
                Loader.stop()
                switch result {
                case .success(let basket):
                    self?.item.basket = basket
                case .failure:
                    break
                }
            }
        }
    }

    private func updateItem(itemId: String, price: Double, units: [BasketUnitPayload]) {
        guard let basketId = item.basket?.id else { return }
        guard !units.isEmpty else {
            Alert.showAlert(forState: .warning, message: L(.enterQuantity), vibrationType: .warning)
            return
        }

        item.isUpdatingItem = true
        Loader.start()
        let payload = BasketItemUpdatePayload(basket_item_id: itemId, price: price, units: units)
        basketService.updateItem(model: BasketUpdateItemRequest(basket_id: basketId, item: payload)) { [weak self] result in
            DispatchQueue.main.async {
                Loader.stop()
                self?.item.isUpdatingItem = false
                switch result {
                case .success(let basket):
                    self?.item.basket = basket
                    self?.item.editingItem = nil
                    Alert.showAlert(forState: .success, message: L(.itemUpdated), vibrationType: .success)
                case .failure:
                    break
                }
            }
        }
    }
}
