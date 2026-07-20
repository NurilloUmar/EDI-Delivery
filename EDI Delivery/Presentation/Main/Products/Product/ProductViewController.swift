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
        navigationItem.title = L(.products)
        view.backgroundColor = .systemBackground
        addSwiftUI(view: ProductView(viewModel: viewModel))
        viewModel.handleEvent(eventType: .viewDidLoad)
        setupRefreshButton()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // Savat holati o'zgargan bo'lishi mumkin (masalan tovar qo'shildi/o'chirildi) —
        // yashil borderlar to'g'ri bo'lishi uchun savatni yengil yangilaymiz.
        viewModel.handleEvent(eventType: .refreshBasket)
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
