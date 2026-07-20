import UIKit
import SwiftUI
internal import Combine

class BasketViewController: BaseViewController {

    internal let viewModel: BasketViewModel

    init(viewModel: BasketViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = L(.submit)
        view.backgroundColor = .systemBackground
        addSwiftUI(view: BasketView(viewModel: viewModel))
        setupRefreshButton()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        viewModel.handleEvent(eventType: .refresh)
    }
    
    private func setupRefreshButton() {
        let refreshButton = UIBarButtonItem(
            image: UIImage(systemName: "arrow.clockwise"),
            style: .plain,
            target: self,
            action: #selector(didTapRefresh)
        )
        refreshButton.tintColor = .label

        let moreButton = UIBarButtonItem(
            image: UIImage(systemName: "ellipsis.circle"),
            menu: UIMenu(children: [
                UIAction(title: L(.clear), image: UIImage(systemName: "trash"), attributes: .destructive) { [weak self] _ in
                    self?.viewModel.handleEvent(eventType: .clearBasket)
                }
            ])
        )
        moreButton.tintColor = .label

        navigationItem.rightBarButtonItems = [moreButton, refreshButton]
    }

    @objc private func didTapRefresh() {
        viewModel.handleEvent(eventType: .refresh)
    }
    
    
}
