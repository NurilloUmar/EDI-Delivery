
import UIKit
internal import Combine

enum LoginEvent {
    case didTapContinue
    case viewDidLoad
}

class LoginViewModel: ObservableObject {

    private let authService: AuthService
    private let navigation: LoginNavigation

    @Published var item: LoginUIState

    init(navigation: LoginNavigation, authService: AuthService) {
        self.item = .init()
        self.navigation = navigation
        self.authService = authService
    }
    
    @MainActor
    func handleEvent(eventType: LoginEvent) {
        switch eventType {
        case .didTapContinue:
            setLogin()
        case .viewDidLoad:
            break
        }
    }
    
    func setLogin() {
        Loader.start()
        let phone = "998\(item.username.trimmingCharacters(in: .whitespaces))"
        authService.login(model: LoginRequest(username: phone, password: item.password.trimmingCharacters(in: .whitespaces))) { [weak self] result in
            Loader.stop()
            switch result {
            case.success(let response):
                guard let token = response.token else { return }
                Cache.share.saveUserToken(token: "Bearer \(token)")
                self?.getMe()
                self?.navigation.routeToTabbar()
            case .failure:
                break
            }
        }
    }
    
    func getMe() {
        authService.getMe { result in
            switch result {
            case .success(let response):
                guard let user = response else {return}
                Cache.share.saveUser(user: user)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
}
