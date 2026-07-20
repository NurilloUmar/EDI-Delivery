import UIKit
internal import Combine

enum DocumentDetailEvent {
    case viewDidLoad
}

class DocumentDetailViewModel: ObservableObject {

    private let documentService: DocumentService
    private let navigation: DocumentDetailNavigation
    private let documentId: String

    @Published var item: DocumentDetailUIState

    init(navigation: DocumentDetailNavigation, documentService: DocumentService, documentId: String) {
        self.item = .init()
        self.navigation = navigation
        self.documentService = documentService
        self.documentId = documentId
    }

    @MainActor
    func handleEvent(eventType: DocumentDetailEvent) {
        switch eventType {
        case .viewDidLoad:
            fetchDocument()
        }
    }

    private func fetchDocument() {
        Loader.start()
        documentService.getDocument(id: documentId) { [weak self] result in
            guard let self else { return }
            DispatchQueue.main.async {
                Loader.stop()
                switch result {
                case .success(let doc):
                    self.item.document = doc
                case .failure:
                    break
                }
            }
        }
    }
}
