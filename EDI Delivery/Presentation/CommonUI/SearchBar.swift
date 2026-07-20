import SwiftUI

struct SearchBar: View {
    @Binding var text: String
    @FocusState private var isFocused: Bool

    var body: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundColor(.gray)

            TextField(L(.search), text: $text)
                .focused($isFocused)
                .autocapitalization(.none)
                .disableAutocorrection(true)
        }
        .padding(12)
        .background(Color(.systemGray6))
        .cornerRadius(12)
        .contentShape(Rectangle())
        .onTapGesture { isFocused = true }
        .padding(.horizontal)
        .padding(.top, 12)
    }

}
