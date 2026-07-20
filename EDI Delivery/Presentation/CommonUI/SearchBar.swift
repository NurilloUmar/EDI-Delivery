import SwiftUI

struct SearchBar: View {
    @Binding var text: String
    @ObservedObject private var lang = LanguageManager.shared

    var body: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundColor(.gray)

            TextField(lang[.search_placeholder], text: $text)
                .autocapitalization(.none)
                .disableAutocorrection(true)
        }
        .padding(12)
        .background(Color(.systemGray6))
        .cornerRadius(12)
        .padding(.horizontal)
        .padding(.top, 12)
    }
}
