internal import Foundation

struct ErrorData: Error, Equatable {
    let code: Int
    let errorMessage: String

    init(error: Error) {
        code = (error as NSError).code
        errorMessage = error.localizedDescription
    }
    
    init(errorMessage: String) {
        code = 0
        self.errorMessage = errorMessage
    }
}
