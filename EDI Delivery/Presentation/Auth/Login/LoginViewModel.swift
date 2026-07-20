
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
        authService.login(model: LoginRequest(username: item.username, password: item.password)) { [weak self] result in
            Loader.stop()
            switch result {
            case.success(let response):
                guard let token = response.data?.token else { return }
                Cache.share.saveUserToken(token: "Bearer \(token)")
                self?.getMe()
                self?.navigation.routeToTabbar()
            case.failure(let error):
                Alert.showAlert(forState: .error, message: error.localizedDescription, vibrationType: .error)
            }
        }
    }
    
    func getMe() {
        authService.getMe { result in
            switch result {
            case .success(let response):
                guard let user = response.data else { return }
                Cache.share.saveUser(user: user)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
}
