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

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(title)
                .font(.system(size: 14, weight: .medium))
                .foregroundColor(.secondary)
            HStack(spacing: 6) {
                Text("+998")
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(.primary)
                TextField("XX XXX XX XX", text: $text)
                    .font(.system(size: 16))
                    .focused($isFocused)
                    .keyboardType(.numberPad)
                    .textContentType(.telephoneNumber)
                    .onChange(of: text) { newValue in
                        let digits = newValue.filter { $0.isNumber }
                        text = String(digits.prefix(9))
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
