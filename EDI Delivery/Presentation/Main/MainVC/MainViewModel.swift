
import UIKit
internal import Combine

enum MainEvent {
    case viewDidLoad
    case refresh
    case didTapProfile
    case didTapToProduct
    case didTapToBranch
    case didTapToOrder
    case didTapToBasket
    case didTapDocument
}

class MainViewModel: ObservableObject {

    private let authService: AuthService
    private let navigation: MainNavigation

    @Published var item: MainUIState

    init(navigation: MainNavigation, authService: AuthService) {
        self.item = .init()
        self.navigation = navigation
        self.authService = authService
    }

    var greetingName: String {
        let full = item.user?.name ?? ""
        return full.split(separator: " ").first.map(String.init) ?? full
    }

    @MainActor
    func handleEvent(eventType: MainEvent) {
        switch eventType {
        case .viewDidLoad:
            item.user = Cache.share.getUser()
            fetchUser()
        case .refresh:
            fetchUser()
        case .didTapProfile:
            navigation.routeToProfile()
        case .didTapToProduct:
            navigation.routeToProduct()
        case .didTapToBranch:
            navigation.routeToBranch()
        case .didTapToOrder:
            navigation.routeToOrder()
        case .didTapToBasket:
            navigation.routeToBasket()
        case .didTapDocument:
            navigation.routeToDocument()
        }
    }

    private func fetchUser() {
        authService.getMe { [weak self] result in
            guard let self else { return }
            DispatchQueue.main.async {
                switch result {
                case .success(let user):
                    if let user {
                        self.item.user = user
                        Cache.share.saveUser(user: user)
                    }
                case .failure:
                    break
                }
            }
        }
    }
}
