import UIKit

class DocumentDetailViewController: BaseViewController {

    private let viewModel: DocumentDetailViewModel

    init(viewModel: DocumentDetailViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = L(.document)
        addSwiftUI(view: DocumentDetailView(viewModel: viewModel))
        viewModel.handleEvent(eventType: .viewDidLoad)
    }
}
