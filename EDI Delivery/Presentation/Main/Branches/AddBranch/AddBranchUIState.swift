internal import Foundation

struct AddBranchUIState {
    var branchName: String = ""
    var branchCode: String = ""
    var address: String = ""
    var innPinfl: String = ""
    var clients: [ClientResponse] = []
    var regions: [RegionResponse] = []
    var districts: [DistrictResponse] = []
    var selectedClient: ClientResponse? = nil
    var selectedRegion: RegionResponse? = nil
    var selectedDistrict: DistrictResponse? = nil
    var isSubmitting: Bool = false

    var isValid: Bool {
        !branchName.isEmpty && !branchCode.isEmpty && selectedClient != nil
    }
}
