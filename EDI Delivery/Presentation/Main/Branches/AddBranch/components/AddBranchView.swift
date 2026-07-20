import SwiftUI

struct AddBranchView: View {
    
    @ObservedObject var viewModel: AddBranchViewModel

    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                sectionHeader(L(.client))

                if !viewModel.item.clients.isEmpty {
                    DropdownPicker(
                        title: L(.clientRequired),
                        placeholder: L(.selectClient),
                        selected: viewModel.item.selectedClient?.name,
                        items: viewModel.item.clients.map { $0.name ?? "" }
                    ) { index in
                        viewModel.handleEvent(eventType: .selectClient(viewModel.item.clients[index]))
                    }
                }

                sectionHeader(L(.branchInfo))

                FormField(title: L(.branchNameRequired), placeholder: L(.branchName), text: $viewModel.item.branchName)
                FormField(title: L(.branchCodeRequired), placeholder: L(.code), text: $viewModel.item.branchCode)
                FormField(title: L(.address), placeholder: L(.streetHouse), text: $viewModel.item.address)
                FormField(title: "INN/PINFL", placeholder: L(.optional), text: $viewModel.item.innPinfl)

                sectionHeader(L(.location))

                if !viewModel.item.regions.isEmpty {
                    DropdownPicker(
                        title: L(.region),
                        placeholder: L(.selectRegion),
                        selected: viewModel.item.selectedRegion?.name,
                        items: viewModel.item.regions.map { $0.name ?? "" }
                    ) { index in
                        viewModel.handleEvent(eventType: .selectRegion(viewModel.item.regions[index]))
                    }
                }

                if !viewModel.item.districts.isEmpty {
                    DropdownPicker(
                        title: L(.district),
                        placeholder: L(.selectDistrict),
                        selected: viewModel.item.selectedDistrict?.name,
                        items: viewModel.item.districts.map { $0.name ?? "" }
                    ) { index in
                        viewModel.handleEvent(eventType: .selectDistrict(viewModel.item.districts[index]))
                    }
                }
                PrimaryButton(title: L(.save)) {
                    viewModel.handleEvent(eventType: .submit)
                }
                .disabled(viewModel.item.isSubmitting)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
        }
        .background(Color(.systemGroupedBackground))
    }

    private func sectionHeader(_ title: String) -> some View {
        Text(title)
            .font(.system(size: 13, weight: .semibold))
            .foregroundColor(.secondary)
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.top, 4)
    }
}
