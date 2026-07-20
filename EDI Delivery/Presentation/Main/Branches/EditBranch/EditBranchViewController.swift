import UIKit

class EditBranchViewController: BaseViewController {

    private let viewModel: EditBranchViewModel

    init(viewModel: EditBranchViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = L(.editBranch)
        addSwiftUI(view: EditBranchView(viewModel: viewModel))
        viewModel.handleEvent(eventType: .viewDidLoad)
    }
}
