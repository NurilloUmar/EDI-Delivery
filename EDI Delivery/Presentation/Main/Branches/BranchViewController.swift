import UIKit
import SwiftUI
internal import Combine

class BranchViewController: BaseViewController {

    internal let viewModel: BranchViewModel

    init(viewModel: BranchViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = L(.salesPoints)
        view.backgroundColor = .systemBackground
        addSwiftUI(view: BranchView(viewModel: viewModel))
        setupRefreshButton()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.handleEvent(eventType: .viewDidLoad)
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
