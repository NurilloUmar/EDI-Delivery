import UIKit

class AddClientViewController: BaseViewController {

    private let viewModel: AddClientViewModel

    init(viewModel: AddClientViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = L(.newClient)
        addSwiftUI(view: AddClientView(viewModel: viewModel))
        viewModel.handleEvent(eventType: .viewDidLoad)
    }
}
