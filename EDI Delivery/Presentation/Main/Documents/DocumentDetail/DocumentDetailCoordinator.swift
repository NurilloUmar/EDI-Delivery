import UIKit

protocol DocumentDetailNavigation {}

class DocumentDetailCoordinator: Coordinator {
    private(set) weak var viewController: BaseViewController?
    private let documentId: String

    init(documentId: String) {
        self.documentId = documentId
    }

    func start() -> BaseViewController {
        let viewModel = DocumentDetailViewModel(
            navigation: self,
            documentService: DIContainer.shared.resolver.get(),
            documentId: documentId
        )
        let viewController = DocumentDetailViewController(viewModel: viewModel)
        self.viewController = viewController
        return viewController
    }
}

extension DocumentDetailCoordinator: DocumentDetailNavigation {}
