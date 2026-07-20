import UIKit
import SwiftUI
internal import Combine

class DocumentViewController: BaseViewController {

    internal let viewModel: DocumentViewModel

    init(viewModel: DocumentViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = L(.report)
        view.backgroundColor = .systemBackground
        addSwiftUI(view: DocumentView(viewModel: viewModel))
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
