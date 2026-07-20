import UIKit

class OrderDetailViewController: BaseViewController {

    internal let viewModel: OrderDetailViewModel

    init(viewModel: OrderDetailViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = L(.orderDetail)
        view.backgroundColor = .appBackground
        addSwiftUI(view: OrderDetailView(viewModel: viewModel), backgroundColor: .appBackground)
        viewModel.handleEvent(eventType: .viewDidLoad)
    }
}
