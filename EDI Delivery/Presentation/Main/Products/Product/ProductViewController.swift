import UIKit
import SwiftUI
internal import Combine

class ProductViewController: BaseViewController {

    internal let viewModel: ProductViewModel
    private var cancellables = Set<AnyCancellable>()

    init(viewModel: ProductViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Mahsulotlar"
        view.backgroundColor = .systemBackground

        addSwiftUI(view: ProductView(viewModel: viewModel))
        viewModel.handleEvent(eventType: .viewDidLoad)
        setupRefreshButton()
    }

    private func setupRefreshButton() {
        let refreshButton = UIBarButtonItem(
            image: UIImage(systemName: "arrow.clockwise"),
            style: .plain,
            target: self,
            action: #selector(didTapRefresh)
        )
        refreshButton.tintColor = .label
        navigationItem.rightBarButtonItem = refreshButton
    }

    @objc private func didTapRefresh() {
        viewModel.handleEvent(eventType: .refresh)
    }
}
