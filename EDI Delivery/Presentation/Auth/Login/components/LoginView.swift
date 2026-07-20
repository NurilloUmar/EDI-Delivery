import SwiftUI

struct LoginView: View {
    @ObservedObject var viewModel: LoginViewModel
    @ObservedObject private var lang = LanguageManager.shared

    var body: some View {
        VStack(spacing: 24) {
            Spacer().frame(height: 40)

            Image(.hippo)
                .resizable()
                .scaledToFit()
                .frame(height: 70)
                .foregroundColor(.blue)
                .padding(.bottom, 30)

            VStack(spacing: 16) {

                LoginInputField(
                    title: lang[.login_username_title],
                    placeholder: lang[.login_username_placeholder],
                    text: $viewModel.item.username,
                    isSecure: false
                )
                .keyboardType(.default)

                LoginInputField(
                    title: lang[.login_password_title],
                    placeholder: lang[.login_password_placeholder],
                    text: $viewModel.item.password,
                    isSecure: true
                )
            }
            .padding(.horizontal)

            Button(action: {
                viewModel.handleEvent(eventType: .didTapContinue)
            }) {
                Text(lang[.login_button])
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .frame(height: 50)
                    .background(viewModel.item.isEnabled ? AppColor.brand : Color.gray.opacity(0.4))
                    .cornerRadius(12)
            }
            .disabled(!viewModel.item.isEnabled)
            .padding(.horizontal)
            .padding(.top, 10)

            Spacer()
        }
        .padding()
        .ignoresSafeArea(.keyboard, edges: .bottom)
    }
}


