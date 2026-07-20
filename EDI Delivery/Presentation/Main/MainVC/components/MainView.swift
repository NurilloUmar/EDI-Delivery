import SwiftUI

struct MainView: View {
    @ObservedObject var viewModel: MainViewModel

    var body: some View {
        
        VStack(spacing: 0) {
            headerRow

            ScrollView {
                LazyVStack(spacing: 12) {
                    ForEach(viewModel.item.menuItems) { item in
                        Button {
                            dispatch(for: item.number)
                        } label: {
                            MainMenuTile(item: item)
                        }
                        .buttonStyle(.plain)
                    }
                }
                .padding(.horizontal, 16)
                .padding(.top, 20)
                .padding(.bottom, 20)
            }
        }
        .background(Color(.systemBackground))
        .onAppear { viewModel.handleEvent(eventType: .viewDidLoad) }
    }

    private var headerRow: some View {
        HStack(spacing: 8) {
            Button {
                viewModel.handleEvent(eventType: .didTapProfile)
            } label: {
                HStack(spacing: 6) {
                    if viewModel.item.user != nil {
                        Text(Loc.greeting(viewModel.greetingName))
                            .font(.system(size: 20, weight: .bold))
                            .foregroundColor(.primary)
                        Image(systemName: "chevron.right")
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundColor(.primary)
                    } else {
                        Text(L(.home))
                            .font(.system(size: 22, weight: .bold))
                            .foregroundColor(.primary)
                        ProgressView()
                            .scaleEffect(0.8)
                    }
                }
            }
            .buttonStyle(.plain)
            Spacer()

            Button {
                viewModel.handleEvent(eventType: .refresh)
            } label: {
                Image(systemName: "arrow.clockwise")
                    .font(.system(size: 22, weight: .medium))
                    .foregroundColor(.primary)
            }
        }
        .padding(.horizontal, 16)
        .padding(.top, 16)
        .padding(.bottom, 4)
    }

    private func dispatch(for number: Int) {
        switch number {
        case 1: viewModel.handleEvent(eventType: .didTapToOrder)
        case 2: viewModel.handleEvent(eventType: .didTapToBasket)
        case 3: viewModel.handleEvent(eventType: .didTapToProduct)
        case 4: viewModel.handleEvent(eventType: .didTapToBranch)
        case 5: viewModel.handleEvent(eventType: .didTapDocument)
        default: break
        }
    }
}

private struct MainMenuTile: View {
    let item: MenuItem

    var body: some View {
        VStack(spacing: 6) {
            Image(systemName: item.icon)
                .font(.system(size: 24, weight: .regular))
                .foregroundColor(AppColor.brand)
            Text(item.title)
                .font(.system(size: 16, weight: .medium))
                .foregroundColor(.primary.opacity(0.8))
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 20)
        .background(Color(.systemGray6))
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}
