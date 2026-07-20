internal import Foundation

struct AddClientUIState {
    var clientName: String = ""
    var clientCode: String = ""
    var phoneNumber: String = ""
    var branchName: String = ""
    var branchCode: String = ""
    var address: String = ""
    var innPinfl: String = ""
    var regions: [RegionResponse] = []
    var districts: [DistrictResponse] = []
    var selectedRegion: RegionResponse? = nil
    var selectedDistrict: DistrictResponse? = nil
    var isSubmitting: Bool = false

    var isValid: Bool {
        !clientName.isEmpty && !clientCode.isEmpty && !phoneNumber.isEmpty
            && !branchName.isEmpty && !branchCode.isEmpty
    }
}
