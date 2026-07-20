import UIKit

class AddBranchViewController: BaseViewController {

    private let viewModel: AddBranchViewModel

    init(viewModel: AddBranchViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = L(.newBranch)
        addSwiftUI(view: AddBranchView(viewModel: viewModel))
        viewModel.handleEvent(eventType: .viewDidLoad)
    }
}
