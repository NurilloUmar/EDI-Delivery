import SwiftUI

// MARK: - Profile View

struct ProfileView: View {

    @ObservedObject var viewModel: ProfileViewModel
    @ObservedObject private var localization = LocalizationManager.shared
    @State private var showLanguagePicker = false

    private var appVersion: String {
        let v = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "1.0"
        return "Edi Delivery v\(v)"
    }

    var body: some View {
        List {

            // MARK: - User

            Section {
                userRow
            }

            // MARK: - Organization

            if viewModel.item.user.organization != nil {
                Section(L(.organization)) {
                    organizationRows
                }
            }

            // MARK: - Settings

            Section {
                Button {
                    showLanguagePicker = true
                } label: {
                    HStack(spacing: 12) {
                        settingsIcon("globe", color: AppColor.brand)
                        Text(L(.language))
                            .foregroundColor(.primary)
                        Spacer()
                        Text("\(localization.language.flag) \(localization.language.nativeName)")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                        Image(systemName: "chevron.right")
                            .font(.system(size: 13, weight: .semibold))
                            .foregroundColor(Color(.tertiaryLabel))
                    }
                }
            }

            // MARK: - Actions

            Section {
                Button(role: .destructive) {
                    viewModel.handleEvent(eventType: .didTapLogout)
                } label: {
                    HStack(spacing: 12) {
                        settingsIcon("rectangle.portrait.and.arrow.right", color: AppColor.danger)
                        Text(L(.logout))
                    }
                }

                Button(role: .destructive) {
                    viewModel.handleEvent(eventType: .didTapDeleteAccount)
                } label: {
                    HStack(spacing: 12) {
                        settingsIcon("trash", color: AppColor.danger)
                        Text(L(.deleteAccount))
                    }
                }
            } footer: {
                Text(appVersion)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding(.top, 8)
            }
        }
        .listStyle(.insetGrouped)
        .alert(L(.logout), isPresented: $viewModel.item.showLogoutAlert) {
            Button(L(.logout), role: .destructive) {
                viewModel.handleEvent(eventType: .confirmLogout)
            }
            Button(L(.cancel), role: .cancel) {}
        } message: {
            Text(L(.logoutConfirmMessage))
        }
        .alert(L(.deleteAccount), isPresented: $viewModel.item.showDeleteAlert) {
            Button(L(.deleteAccount), role: .destructive) {
                viewModel.handleEvent(eventType: .confirmDelete)
            }
            Button(L(.cancel), role: .cancel) {}
        } message: {
            Text(L(.deleteAccountConfirmMessage))
        }
        .sheet(isPresented: $showLanguagePicker) {
            LanguagePickerSheet(
                selected: localization.language,
                onSelect: { lang in
                    showLanguagePicker = false
                    localization.setLanguage(lang)
                },
                onDismiss: { showLanguagePicker = false }
            )
        }
    }

    // MARK: - User Row

    private var userRow: some View {
        HStack(spacing: 14) {
            ZStack {
                Circle()
                    .fill(AppColor.brand.opacity(0.15))
                    .frame(width: 52, height: 52)
                Image(systemName: "person.fill")
                    .font(.system(size: 22))
                    .foregroundColor(AppColor.brand)
            }

            VStack(alignment: .leading, spacing: 4) {
                Text(viewModel.item.user.name ?? "—")
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(.primary)

                if let username = viewModel.item.user.username, !username.isEmpty {
                    Text("+\(username)")
                        .font(.system(size: 14))
                        .foregroundColor(.secondary)
                }

                if let mark = viewModel.item.user.car_mark, !mark.isEmpty {
                    HStack(spacing: 8) {
                        Text(mark)
                            .font(.system(size: 13, weight: .medium))
                            .foregroundColor(.secondary)
                        if let plate = viewModel.item.user.car_serial_number, !plate.isEmpty {
                            CarPlateView(plate: plate)
                        }
                    }
                    .padding(.top, 2)
                }
            }
            Spacer()
        }
        .padding(.vertical, 6)
    }

    // MARK: - Organization Rows

    @ViewBuilder
    private var organizationRows: some View {
        HStack {
            Text(viewModel.item.user.organization?.name ?? "—")
                .font(.system(size: 15, weight: .medium))
                .foregroundColor(.primary)
            Spacer()
        }

        HStack {
            Text("INN/PINFL")
                .foregroundColor(.secondary)
            Spacer()
            Text(
                viewModel.item.user.organization?.inn
                ?? viewModel.item.user.organization?.pinfl
                ?? "—"
            )
            .foregroundColor(.primary)
        }
    }

    private func settingsIcon(_ name: String, color: Color) -> some View {
        ZStack {
            RoundedRectangle(cornerRadius: 7)
                .fill(color)
                .frame(width: 29, height: 29)
            Image(systemName: name)
                .font(.system(size: 15, weight: .semibold))
                .foregroundColor(.white)
        }
    }
}

// MARK: - Language Picker Bottom Sheet

struct LanguagePickerSheet: View {
    let selected: AppLanguage
    let onSelect: (AppLanguage) -> Void
    let onDismiss: () -> Void

    var body: some View {
        VStack(spacing: 0) {
            BottomSheetHeader(title: L(.language), onClose: onDismiss)

            VStack(spacing: 0) {
                ForEach(Array(AppLanguage.allCases.enumerated()), id: \.element) { index, lang in
                    Button {
                        onSelect(lang)
                    } label: {
                        HStack(spacing: 12) {
                            Text(lang.flag)
                                .font(.system(size: 24))
                            Text(lang.nativeName)
                                .font(.system(size: 16, weight: .medium))
                                .foregroundColor(.primary)
                            Spacer()
                            if lang == selected {
                                Image(systemName: "checkmark")
                                    .font(.system(size: 15, weight: .semibold))
                                    .foregroundColor(AppColor.brand)
                            }
                        }
                        .padding(.horizontal, 16)
                        .frame(height: 56)
                        .contentShape(Rectangle())
                    }
                    .buttonStyle(.plain)

                    if index < AppLanguage.allCases.count - 1 {
                        Divider().padding(.leading, 52)
                    }
                }
            }
            .background(Color(.systemGray6))
            .clipShape(RoundedRectangle(cornerRadius: 14))
            .padding(.horizontal, 16)

            Spacer(minLength: 0)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        .background(Color(.systemBackground))
        .bottomSheetChrome(detents: [.height(320)])
    }
}

// MARK: - Car Plate View

struct CarPlateView: View {

    let plate: String

    var body: some View {

        HStack(spacing: 4) {

            Text(plate)
                .font(.system(size: 14, weight: .bold))
                .foregroundColor(
                    Color(
                        red: 49/255,
                        green: 65/255,
                        blue: 88/255
                    )
                )

            VStack(spacing: 0) {

                Text("🇺🇿")
                    .font(.system(size: 8))

                Text("UZ")
                    .font(.system(size: 8, weight: .bold))
            }
        }
        .padding(.horizontal, 8)
        .padding(.vertical, 4)
        .background(Color.white)
        .overlay(
            RoundedRectangle(cornerRadius: 6)
                .stroke(
                    Color(
                        red: 15/255,
                        green: 23/255,
                        blue: 43/255
                    ),
                    lineWidth: 1
                )
        )
        .clipShape(RoundedRectangle(cornerRadius: 6))
    }
}
