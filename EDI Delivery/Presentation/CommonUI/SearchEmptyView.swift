import SwiftUI

struct SearchEmptyView: View {
    var body: some View {
        VStack(alignment: .center) {
            Image(.searchEmpty)
            Text(L(.nothingFound))
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity)
    }
}
