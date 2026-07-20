import UIKit
internal import Combine

enum ProfileEvent {
    case viewDidLoad
    case didTapLogout
    case didTapDeleteAccount
    case confirmLogout
    case confirmDelete
}

class ProfileViewModel: ObservableObject {

    private let authService: AuthService
    private let navigation: ProfileNavigation
    @Published var item: ProfileUIState

    init(navigation: ProfileNavigation, authService: AuthService) {
        self.item = .init()
        self.navigation = navigation
        self.authService = authService
    }

    @MainActor
    func handleEvent(eventType: ProfileEvent) {
        switch eventType {
        case .viewDidLoad:
            item.user = Cache.share.getUser() ?? UserData()
            fetchUser()
        case .didTapLogout:
            item.showLogoutAlert = true
        case .didTapDeleteAccount:
            item.showDeleteAlert = true
        case .confirmLogout, .confirmDelete:
            logOutServices()
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

    private func logOutServices() {
        Loader.start()
        authService.logOut { [weak self] result in
            Loader.stop()
            guard let self else { return }
            switch result {
            case .success:
                Cache.share.deleteUserToken()
                self.navigation.routeToAuth()
            case .failure:
                break
            }
        }
    }
}
