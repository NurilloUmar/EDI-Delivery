import UIKit
internal import Combine

enum DocumentEvent {
    case viewDidLoad
    case refresh
    case filterByDate(Date)
    case didSelectDocument(id: String)
}

class DocumentViewModel: ObservableObject {

    private let documentService: DocumentService
    private let navigation: DocumentNavigation

    @Published var item: DocumentUIState

    init(navigation: DocumentNavigation, documentService: DocumentService) {
        self.item = .init()
        self.navigation = navigation
        self.documentService = documentService
    }

    var filteredDocuments: [DocumentResponse] {
        guard !item.searchText.isEmpty else { return item.items }
        return item.items.filter {
            ($0.clientBranch?.name ?? "").localizedCaseInsensitiveContains(item.searchText) ||
            ($0.number ?? "").localizedCaseInsensitiveContains(item.searchText)
        }
    }

    var totalSum: Double {
        item.items.reduce(0) { $0 + ($1.totalWithVat ?? $1.totalPrice ?? 0) }
    }

    @MainActor
    func handleEvent(eventType: DocumentEvent) {
        switch eventType {
        case .viewDidLoad, .refresh:
            fetchDocuments(date: item.selectedDate)
        case .filterByDate(let date):
            item.selectedDate = date
            fetchDocuments(date: date)
        case .didSelectDocument(let id):
            navigation.routeToDocumentDetail(id: id)
        }
    }

    private func fetchDocuments(date: Date) {
        let formatter = DateFormatter.apiDateFormatter
        let dateStr = formatter.string(from: date)
        let model = DocumentRequest(date_start: dateStr, date_end: dateStr)
        Loader.start()
        documentService.getDocuments(model: model) { [weak self] result in
            guard let self else { return }
            DispatchQueue.main.async {
                Loader.stop()
                switch result {
                case .success(let documents):
                    self.item.items = documents ?? []
                case .failure:
                    break
                }
            }
        }
    }
}
