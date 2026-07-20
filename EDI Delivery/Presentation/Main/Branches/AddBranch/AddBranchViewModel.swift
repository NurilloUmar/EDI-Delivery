import UIKit
internal import Combine

enum AddBranchEvent {
    case viewDidLoad
    case selectClient(ClientResponse)
    case selectRegion(RegionResponse)
    case selectDistrict(DistrictResponse)
    case submit
}

class AddBranchViewModel: ObservableObject {

    private let branchService: BranchService
    private let navigation: AddBranchNavigation

    @Published var item: AddBranchUIState

    init(navigation: AddBranchNavigation, branchService: BranchService) {
        self.item = .init()
        self.navigation = navigation
        self.branchService = branchService
    }

    @MainActor
    func handleEvent(eventType: AddBranchEvent) {
        switch eventType {
        case .viewDidLoad:
            fetchClients()
            fetchRegions()
        case .selectClient(let client):
            item.selectedClient = client
        case .selectRegion(let region):
            item.selectedRegion = region
            item.selectedDistrict = nil
            item.districts = []
            if let code = region.code {
                fetchDistricts(regionCode: code)
            }
        case .selectDistrict(let district):
            item.selectedDistrict = district
        case .submit:
            registerBranch()
        }
    }

    private func fetchClients() {
        branchService.getClients { [weak self] result in
            guard let self else { return }
            DispatchQueue.main.async {
                switch result {
                case .success(let clients): self.item.clients = clients
                case .failure: break
                }
            }
        }
    }

    private func fetchRegions() {
        branchService.getRegions { [weak self] result in
            guard let self else { return }
            DispatchQueue.main.async {
                switch result {
                case .success(let regions): self.item.regions = regions
                case .failure: break
                }
            }
        }
    }

    private func fetchDistricts(regionCode: Int) {
        branchService.getDistricts(regionCode: regionCode) { [weak self] result in
            guard let self else { return }
            DispatchQueue.main.async {
                switch result {
                case .success(let districts): self.item.districts = districts
                case .failure: break
                }
            }
        }
    }

    private func registerBranch() {
        guard item.isValid, let clientId = item.selectedClient?.id else {
            Alert.showAlert(forState: .warning, message: L(.fillClientAndRequired), vibrationType: .warning)
            return
        }

        let model = BranchRegisterRequest(
            client_id: clientId,
            code: item.branchCode,
            name: item.branchName,
            region_code: item.selectedRegion?.code,
            district_code: item.selectedDistrict?.code,
            street: item.address.isEmpty ? nil : item.address
        )

        item.isSubmitting = true
        Loader.start()
        branchService.registerBranch(model: model) { [weak self] result in
            guard let self else { return }
            DispatchQueue.main.async {
                Loader.stop()
                self.item.isSubmitting = false
                switch result {
                case .success:
                    Alert.showAlert(forState: .success, message: L(.branchAdded), vibrationType: .success)
                    self.navigation.popBack()
                case .failure:
                    break
                }
            }
        }
    }
}
