internal import Foundation

class Cache {
    
    static let share = Cache()
    
    // MARK: - Token
    func saveUserToken(token: String) {
        UserDefaults.standard.set(token, forKey: Keys.userToken)
    }
    
    func getUserToken() -> String? {
        return UserDefaults.standard.string(forKey: Keys.userToken)
    }
    
    func deleteUserToken() {
        UserDefaults.standard.removeObject(forKey: Keys.userToken)
    }
    
    // MARK: - User
    
    func saveUser(user: UserData) {
        do {
            let data = try JSONEncoder().encode(user)
            UserDefaults.standard.set(data, forKey: Keys.userInfo)
        } catch {
            print("User encode error:", error)
        }
    }
    
    func getUser() -> UserData? {
        guard let data = UserDefaults.standard.data(forKey: Keys.userInfo) else {
            return nil
        }
        do {
            let user = try JSONDecoder().decode(UserData.self, from: data)
            return user
        } catch {
            print("User decode error:", error)
            return nil
        }
    }
    
    func deleteUser() {
        UserDefaults.standard.removeObject(forKey: Keys.userInfo)
    }

    // MARK: - Language

    func saveLanguage(_ code: String) {
        UserDefaults.standard.set(code, forKey: Keys.appLanguage)
    }

    func getLanguage() -> String? {
        return UserDefaults.standard.string(forKey: Keys.appLanguage)
    }
}
