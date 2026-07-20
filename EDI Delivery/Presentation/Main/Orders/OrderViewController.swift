import UIKit
import SwiftUI
internal import Combine

class OrderViewController: BaseViewController {

    internal let viewModel: OrderViewModel
    private var cancellables = Set<AnyCancellable>()

    init(viewModel: OrderViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = L(.orders)
        view.backgroundColor = .systemBackground
        addSwiftUI(view: OrderView(viewModel: viewModel))
        setupRightBarItems()
        bindCount()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // Har ko'rinishda qayta yuklaymiz: savat/detaildan qaytilganda buyurtma
        // statusi o'zgargan bo'lishi mumkin (masalan, "Jarayonda"ga o'tadi).
        viewModel.handleEvent(eventType: .refresh)
    }

    private func setupRightBarItems() {
        let refreshButton = UIBarButtonItem(
            image: UIImage(systemName: "arrow.clockwise"),
            style: .plain,
            target: self,
            action: #selector(didTapRefresh)
        )
        refreshButton.tintColor = .label
        navigationItem.rightBarButtonItem = refreshButton
    }

    private func bindCount() {
        viewModel.$item
            .map { $0.items.count }
            .removeDuplicates()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] count in
                self?.navigationItem.title = count > 0 ? "\(L(.orders)) (\(count))" : L(.orders)
            }
            .store(in: &cancellables)
    }

    @objc private func didTapRefresh() {
        viewModel.handleEvent(eventType: .refresh)
    }
}
