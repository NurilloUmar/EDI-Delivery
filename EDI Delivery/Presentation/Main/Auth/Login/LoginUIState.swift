
internal import Foundation

struct LoginUIState {

    var username: String = ""
    var password: String = ""
    var isPasswordVisible: Bool = false

    var isEnabled: Bool {
        username.count == 9 && !password.isEmpty
    }

}
