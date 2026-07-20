import UIKit
internal import Combine

enum AddClientEvent {
    case viewDidLoad
    case selectRegion(RegionResponse)
    case selectDistrict(DistrictResponse)
    case submit
}

class AddClientViewModel: ObservableObject {

    private let branchService: BranchService
    private let navigation: AddClientNavigation

    @Published var item: AddClientUIState

    init(navigation: AddClientNavigation, branchService: BranchService) {
        self.item = .init()
        self.navigation = navigation
        self.branchService = branchService
    }

    @MainActor
    func handleEvent(eventType: AddClientEvent) {
        switch eventType {
        case .viewDidLoad:
            fetchRegions()
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
            registerClient()
        }
    }

    private func fetchRegions() {
        branchService.getRegions { [weak self] result in
            guard let self else { return }
            DispatchQueue.main.async {
                switch result {
                case .success(let regions):
                    self.item.regions = regions
                case .failure:
                    break
                }
            }
        }
    }

    private func fetchDistricts(regionCode: Int) {
        branchService.getDistricts(regionCode: regionCode) { [weak self] result in
            guard let self else { return }
            DispatchQueue.main.async {
                switch result {
                case .success(let districts):
                    self.item.districts = districts
                case .failure:
                    break
                }
            }
        }
    }

    private func registerClient() {
        guard item.isValid else {
            Alert.showAlert(forState: .warning, message: L(.fillAllRequired), vibrationType: .warning)
            return
        }

        let phone = item.phoneNumber.count == 9 ? "998\(item.phoneNumber)" : item.phoneNumber
        let branch = BranchInfoPayload(
            code: item.branchCode,
            name: item.branchName,
            region_code: item.selectedRegion?.code,
            district_code: item.selectedDistrict?.code,
            street: item.address.isEmpty ? nil : item.address
        )
        let model = ClientRegisterRequest(
            username: phone,
            name: item.clientName,
            code: item.clientCode,
            customer_identifier: item.innPinfl.isEmpty ? nil : item.innPinfl,
            branch: branch
        )

        item.isSubmitting = true
        Loader.start()
        branchService.registerClient(model: model) { [weak self] result in
            guard let self else { return }
            DispatchQueue.main.async {
                Loader.stop()
                self.item.isSubmitting = false
                switch result {
                case .success:
                    Alert.showAlert(forState: .success, message: L(.clientAdded), vibrationType: .success)
                    self.navigation.popBack()
                case .failure:
                    break
                }
            }
        }
    }
}
