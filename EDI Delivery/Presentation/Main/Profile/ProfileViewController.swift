import UIKit

class ProfileViewController: BaseViewController {

    internal let viewModel: ProfileViewModel

    init(viewModel: ProfileViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = L(.profile)
        navigationItem.largeTitleDisplayMode = .always
        navigationController?.navigationBar.prefersLargeTitles = true
        viewModel.handleEvent(eventType: .viewDidLoad)
        addSwiftUI(view: ProfileView(viewModel: viewModel))
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        // Boshqa ekranlar katta sarlavha ishlatmaydi — chiqishda o'chiramiz.
        navigationController?.navigationBar.prefersLargeTitles = false
    }
}
