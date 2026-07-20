
internal import Foundation

struct LoginUIState {
    
    var username: String = ""
    var password: String = ""
    
    var isEnabled: Bool {
        !username.isEmpty && !password.isEmpty
    }
    
}
