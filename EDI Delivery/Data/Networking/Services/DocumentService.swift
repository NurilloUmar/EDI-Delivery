internal import Foundation

struct DocumentService: BaseService {
    typealias Convertible = DocumentRouter

    func getDocuments(model: DocumentRequest = .init(), completion: @escaping Completion<[DocumentResponse]?>) {
        request(.getDocuments(model: model), completion: completion)
    }

    func getDocument(id: String, completion: @escaping Completion<DocumentResponse>) {
        request(.getDocument(id: id), completion: completion)
    }
}
