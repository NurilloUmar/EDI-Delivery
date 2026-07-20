import UIKit

protocol DocumentNavigation {
    func routeToDocumentDetail(id: String)
}

class DocumentCoordinator: Coordinator {
    private(set) weak var viewController: BaseViewController?
    func start() -> BaseViewController {
        let viewModel = DocumentViewModel(
            navigation: self,
            documentService: DIContainer.shared.resolver.get()
        )
        let viewController = DocumentViewController(viewModel: viewModel)
        self.viewController = viewController
        return viewController
    }
}

extension DocumentCoordinator: DocumentNavigation {
    func routeToDocumentDetail(id: String) {
        pushTo(coordinator: DocumentDetailCoordinator(documentId: id))
    }
}
