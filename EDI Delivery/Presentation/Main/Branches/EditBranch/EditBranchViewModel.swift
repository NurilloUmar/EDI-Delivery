import UIKit
internal import Combine

enum EditBranchEvent {
    case viewDidLoad
    case selectClient(ClientResponse)
    case selectRegion(RegionResponse)
    case selectDistrict(DistrictResponse)
    case submit
}

class EditBranchViewModel: ObservableObject {

    private let branchService: BranchService
    private let navigation: EditBranchNavigation
    private let branch: BranchResponse

    @Published var item: EditBranchUIState

    init(navigation: EditBranchNavigation, branchService: BranchService, branch: BranchResponse) {
        self.item = .init()
        self.navigation = navigation
        self.branchService = branchService
        self.branch = branch
        self.item.branchName = branch.name ?? ""
        self.item.branchCode = branch.code ?? ""
        self.item.address = branch.street ?? ""

        // Mavjud filial ma'lumotlari picker'larda default tanlangan holda tursin —
        // aks holda ular bo'sh ko'rinib, foydalanuvchini adashtiradi (submit'dagi
        // fallback qiymatlar bilan bir xil).
        if let clientInfo = branch.clientInfo {
            self.item.selectedClient = ClientResponse(
                id: clientInfo.id,
                name: clientInfo.name,
                username: clientInfo.username,
                customer: branch.customer
            )
        }
        if let region = branch.region {
            self.item.selectedRegion = RegionResponse(code: region.code, name: region.name)
        }
        if let district = branch.district {
            self.item.selectedDistrict = DistrictResponse(
                code: district.code,
                name: district.name,
                regionCode: branch.region?.code
            )
        }
    }

    @MainActor
    func handleEvent(eventType: EditBranchEvent) {
        switch eventType {
        case .viewDidLoad:
            fetchClients()
            fetchRegions()
            // Mavjud viloyatning tumanlarini ham yuklaymiz — aks holda tuman
            // picker'i (districts bo'sh bo'lgani uchun) umuman ko'rinmaydi.
            if let code = branch.region?.code {
                fetchDistricts(regionCode: code)
            }
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
            updateBranch()
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

    private func updateBranch() {
        guard item.isValid, let branchId = branch.id else {
            Alert.showAlert(forState: .warning, message: L(.fillRequired), vibrationType: .warning)
            return
        }

        let model = BranchUpdateRequest(
            client_id: item.selectedClient?.id ?? branch.clientInfo?.id,
            code: item.branchCode,
            name: item.branchName,
            region_code: item.selectedRegion?.code ?? branch.region?.code,
            district_code: item.selectedDistrict?.code ?? branch.district?.code,
            street: item.address.isEmpty ? nil : item.address
        )

        item.isSubmitting = true
        Loader.start()
        branchService.updateBranch(id: branchId, model: model) { [weak self] result in
            guard let self else { return }
            DispatchQueue.main.async {
                Loader.stop()
                self.item.isSubmitting = false
                switch result {
                case .success:
                    Alert.showAlert(forState: .success, message: L(.branchUpdated), vibrationType: .success)
                    self.navigation.popBack()
                case .failure:
                    break
                }
            }
        }
    }
}
