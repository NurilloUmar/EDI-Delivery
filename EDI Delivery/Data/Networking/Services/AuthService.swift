internal import Foundation

struct AuthService: BaseService {
    typealias Convertible = LoginRouter
 
    func login(model: LoginRequest, completion: @escaping Completion<LoginResponse>) {
        request(.login(model: model), completion: completion)
    }
    
    func getMe(completion: @escaping Completion<UserData?>) {
        request(.getMe, completion: completion)
    }
    
    func logOut(completion: @escaping Completion<EmptyResponse>){
        request(.logOut, completion: completion)
    }
    
}
