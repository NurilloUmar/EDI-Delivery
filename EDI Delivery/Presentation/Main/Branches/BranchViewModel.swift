import UIKit
internal import Combine

enum BranchEvent {
    case viewDidLoad
    case refresh
    case didTapAddClient
    case didTapAddBranch
    case didTapEditBranch(branch: BranchResponse)
    case didTapView(branch: BranchResponse)
    case dismissDetail
    case didTapAddToBasket(branch: BranchResponse)
}

class BranchViewModel: ObservableObject {

    private let branchService: BranchService
    private let basketService: BasketService
    private let navigation: BranchNavigation

    @Published var item: BranchUIState

    init(navigation: BranchNavigation, branchService: BranchService, basketService: BasketService) {
        self.item = .init()
        self.navigation = navigation
        self.branchService = branchService
        self.basketService = basketService
    }

    var filteredBranches: [BranchResponse] {
        guard !item.searchText.isEmpty else { return item.items }
        return item.items.filter {
            ($0.name ?? "").localizedCaseInsensitiveContains(item.searchText) ||
            ($0.customer?.identifier ?? "").localizedCaseInsensitiveContains(item.searchText) ||
            ($0.code ?? "").localizedCaseInsensitiveContains(item.searchText)
        }
    }

    @MainActor
    func handleEvent(eventType: BranchEvent) {
        switch eventType {
        case .viewDidLoad, .refresh:
            fetchBranches()
        case .didTapAddClient:
            navigation.routeToAddClient()
        case .didTapAddBranch:
            navigation.routeToAddBranch()
        case .didTapEditBranch(let branch):
            navigation.routeToEditBranch(branch: branch)
        case .didTapView(let branch):
            item.detailBranch = branch
        case .dismissDetail:
            item.detailBranch = nil
        case .didTapAddToBasket(let branch):
            addToBasket(branch)
        }
    }

    // MARK: - Add to basket (set this branch's client on the active basket)

    private func addToBasket(_ branch: BranchResponse) {
        let clientId = branch.clientInfo?.id
        let branchId = branch.id
        Loader.start()
        basketService.getBaskets { [weak self] result in
            guard let self else { return }
            DispatchQueue.main.async {
                switch result {
                case .success(let basket):
                    // Savatda item bor va mijoz ALLAQACHON biriktirilgan bo'lsa — klientni
                    // almashtirishni bloklaymiz (joriy mijozning tovarlari boshqasiga o'tmasin).
                    // Mijozsiz (branch == nil) savatga esa mijoz biriktirishga ruxsat beramiz.
                    if let items = basket?.items, !items.isEmpty, basket?.branch != nil {
                        Loader.stop()
                        Alert.showAlert(forState: .warning, message: L(.basketNotEmpty), vibrationType: .warning)
                        return
                    }
                    if let basketId = basket?.id {
                        self.basketService.updateClient(basketId: basketId, clientId: clientId, branchId: branchId) { [weak self] res in
                            self?.handleAddToBasketResult(res)
                        }
                    } else {
                        let model = BasketRegisterRequest(delivery_order_id: nil, client_branch_id: branchId, items: nil)
                        self.basketService.registerBasket(model: model) { [weak self] res in
                            self?.handleAddToBasketResult(res)
                        }
                    }
                case .failure:
                    Loader.stop()
                }
            }
        }
    }

    private func handleAddToBasketResult(_ result: Result<BasketResponse, NetworkError>) {
        DispatchQueue.main.async { [weak self] in
            Loader.stop()
            guard let self else { return }
            switch result {
            case .success:
                Alert.showAlert(forState: .success, message: L(.addedToBasket), vibrationType: .success)
                self.navigation.routeToBasket()
            case .failure:
                break
            }
        }
    }

    private func fetchBranches() {
        Loader.start()
        branchService.getBranches { [weak self] result in
            guard let self else { return }
            DispatchQueue.main.async {
                Loader.stop()
                switch result {
                case .success(let branches):
                    self.item.items = branches
                case .failure:
                    break
                }
            }
        }
    }
}
