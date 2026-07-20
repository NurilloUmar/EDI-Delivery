import SwiftUI

struct SearchEmptyView: View {
    @ObservedObject private var lang = LanguageManager.shared

    var body: some View {
        VStack(alignment: .center) {
            Image(.searchEmpty)
            Text(lang[.search_empty])
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity)
    }
}
