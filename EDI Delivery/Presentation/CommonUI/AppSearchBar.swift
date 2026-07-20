import SwiftUI

/// Yagona qidiruv maydoni: lupada ikon, plaintext maydon, x-clear tugmasi.
struct AppSearchBar: View {

    let placeholder: String
    @Binding var text: String
    var onChange: ((String) -> Void)?

    var body: some View {
        HStack(spacing: AppMetric.spacingMD) {
            Image(systemName: "magnifyingglass")
                .font(.system(size: 18))
                .foregroundColor(.gray)

            TextField(placeholder, text: $text)
                .font(AppFont.body)
                .onChange(of: text) { value in
                    onChange?(value)
                }

            if !text.isEmpty {
                Button {
                    text = ""
                    onChange?("")
                } label: {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(.gray)
                }
            }
        }
        .padding(.horizontal, AppMetric.spacingLG)
        .frame(height: AppMetric.controlHeight)
        .background(AppColor.surfaceMuted)
        .clipShape(RoundedRectangle(cornerRadius: AppMetric.radiusMD))
    }
}
