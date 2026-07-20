import SwiftUI

import SwiftUI

struct LoginView: View {

    @ObservedObject var viewModel: LoginViewModel

    var body: some View {
        ZStack {
            Color(.systemBackground)
                .ignoresSafeArea()

            VStack {
                Image(.hippo)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 262, height: 71)
                    .padding(.top, 40)

                Spacer()
            }

            ScrollView {
                VStack(spacing: 16) {

                    Spacer()
                        .frame(height: 180)

                    LoginNumberField(
                        title: L(.loginField),
                        text: $viewModel.item.username
                    )

                    LoginPasswordField(
                        title: L(.password),
                        placeholder: L(.enterPassword),
                        text: $viewModel.item.password,
                        isVisible: $viewModel.item.isPasswordVisible
                    )
                    .keyboardType(.numbersAndPunctuation)

                    Button {
                        viewModel.handleEvent(eventType: .didTapContinue)
                    } label: {
                        Text(L(.signIn))
                            .font(.system(size: 17, weight: .semibold))
                            .foregroundColor(
                                viewModel.item.isEnabled
                                ? .white
                                : Color.gray
                            )
                            .frame(maxWidth: .infinity)
                            .frame(height: 52)
                            .background(
                                viewModel.item.isEnabled
                                ? AppColor.brand
                                : Color(.systemGray5)
                            )
                            .clipShape(
                                RoundedRectangle(cornerRadius: 12)
                            )
                    }
                    .disabled(!viewModel.item.isEnabled)
                }
                .padding(.horizontal, 16)
                .padding(.bottom, 30)
            }
            .scrollDismissesKeyboard(.interactively)
        }
    }
}

// MARK: - Number Field (9-digit phone)

private struct LoginNumberField: View {
    let title: String
    @Binding var text: String
    @FocusState private var isFocused: Bool

    /// Maydonda ko'rinadigan matn ("XX XXX XX XX" ko'rinishida). Bog'langan
    /// `text` esa doim toza raqamlarda qoladi (maks. 9 xona) — shu tufayli
    /// `isEnabled` tekshiruvi va API chaqiruvi o'zgarmaydi.
    @State private var display: String

    init(title: String, text: Binding<String>) {
        self.title = title
        self._text = text
        self._display = State(initialValue: Self.grouped(text.wrappedValue))
    }

    /// 9 xonagacha raqamni 2-3-2-2 guruhlaydi: "999801234" -> "99 980 12 34"
    private static func grouped(_ raw: String) -> String {
        let digits = Array(raw.prefix(9))
        var groups: [String] = []
        var index = 0
        for size in [2, 3, 2, 2] where index < digits.count {
            let end = min(index + size, digits.count)
            groups.append(String(digits[index..<end]))
            index = end
        }
        return groups.joined(separator: " ")
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(title)
                .font(.system(size: 14, weight: .medium))
                .foregroundColor(.secondary)
            HStack(spacing: 6) {
                Text("+998")
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(.primary)
                TextField("XX XXX XX XX", text: $display)
                    .font(.system(size: 16))
                    .focused($isFocused)
                    .keyboardType(.numberPad)
                    .textContentType(.telephoneNumber)
                    .onChange(of: display) { newValue in
                        var digits = newValue.filter { $0.isNumber }
                        // To'liq xalqaro raqam paste/AutoFill bo'lsa (998 + 9 xona) — 998 ni tashlaymiz.
                        // Aynan 12 xona sharti muhim: "99 8.." bilan boshlanadigan raqamlarga tegmaydi.
                        if digits.count == 12, digits.hasPrefix("998") {
                            digits = String(digits.dropFirst(3))
                        }
                        digits = String(digits.prefix(9))
                        if text != digits { text = digits }

                        // Ortiqcha (10-) raqam maydonga kirmaydi: ko'rinish har doim
                        // formatlangan holatga darhol qaytariladi.
                        let formatted = Self.grouped(digits)
                        if newValue != formatted { display = formatted }
                    }
            }
            .padding(.horizontal, 14)
            .frame(height: 52)
            .background(Color(.systemGray6))
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .contentShape(Rectangle())
            .onTapGesture { isFocused = true }
        }
    }
}

// MARK: - Password Field

private struct LoginPasswordField: View {
    let title: String
    let placeholder: String
    @Binding var text: String
    @Binding var isVisible: Bool
    @FocusState private var isFocused: Bool

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(title)
                .font(.system(size: 14, weight: .medium))
                .foregroundColor(.secondary)
            HStack(spacing: 8) {
                Group {
                    if isVisible {
                        TextField(placeholder, text: $text)
                    } else {
                        SecureField(placeholder, text: $text)
                    }
                }
                .font(.system(size: 16))
                .focused($isFocused)
                .textContentType(.password)

                Button {
                    isVisible.toggle()
                } label: {
                    Image(systemName: isVisible ? "eye.slash" : "eye")
                        .font(.system(size: 16))
                        .foregroundColor(.secondary)
                }
            }
            .padding(.horizontal, 14)
            .frame(height: 52)
            .background(Color(.systemGray6))
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .contentShape(Rectangle())
            .onTapGesture { isFocused = true }
        }
    }
}
