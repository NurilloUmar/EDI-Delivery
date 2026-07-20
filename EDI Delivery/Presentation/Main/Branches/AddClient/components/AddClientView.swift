import SwiftUI

struct AddClientView: View {
    @ObservedObject var viewModel: AddClientViewModel

    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                sectionHeader(L(.clientInfo))

                FormField(title: L(.fullName), placeholder: L(.clientName), text: $viewModel.item.clientName)
                FormField(title: L(.clientCodeRequired), placeholder: L(.code), text: $viewModel.item.clientCode)
                FormField(title: L(.phoneNineDigits), placeholder: "901234567", text: $viewModel.item.phoneNumber)
                    .keyboardType(.numberPad)
                FormField(title: "INN/PINFL", placeholder: L(.optional), text: $viewModel.item.innPinfl)

                sectionHeader(L(.branchInfo))

                FormField(title: L(.branchNameRequired), placeholder: L(.branchName), text: $viewModel.item.branchName)
                FormField(title: L(.branchCodeRequired), placeholder: L(.code), text: $viewModel.item.branchCode)
                FormField(title: L(.address), placeholder: L(.streetHouse), text: $viewModel.item.address)

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

// MARK: - Shared form components

struct FormField: View {
    let title: String
    let placeholder: String
    @Binding var text: String
    var keyboardType: UIKeyboardType = .default
    @FocusState private var isFocused: Bool

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(title)
                .font(.system(size: 13))
                .foregroundColor(.secondary)
            TextField(placeholder, text: $text)
                .font(.system(size: 16))
                .focused($isFocused)
                .keyboardType(keyboardType)
                .padding(12)
                // Tap-to-focus'ni TextField ORQASIDAGI background'ga qo'yamiz: matn ustiga
                // bosganda kursor to'g'ri joylashadi, atrofdagi padding'ga bosganda fokus oladi.
                .background(
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color(.systemBackground))
                        .onTapGesture { isFocused = true }
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(isFocused ? AppColor.brand : Color(.systemGray4), lineWidth: 1)
                        .allowsHitTesting(false)
                )
                .animation(.easeInOut(duration: 0.15), value: isFocused)
        }
    }
}

struct DropdownPicker: View {
    let title: String
    let placeholder: String
    let selected: String?
    let items: [String]
    let onSelect: (Int) -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(title)
                .font(.system(size: 13))
                .foregroundColor(.secondary)
            Menu {
                ForEach(Array(items.enumerated()), id: \.offset) { index, name in
                    Button(name) { onSelect(index) }
                }
            } label: {
                HStack {
                    Text(selected ?? placeholder)
                        .font(.system(size: 16))
                        .foregroundColor(selected != nil ? .primary : .secondary)
                    Spacer()
                    Image(systemName: "chevron.down")
                        .font(.system(size: 13))
                        .foregroundColor(.secondary)
                }
                .padding(12)
                .background(
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color(.systemBackground))
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color(.systemGray4), lineWidth: 1)
                )
            }
        }
    }
}
