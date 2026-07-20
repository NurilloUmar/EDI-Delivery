import SwiftUI

struct BranchView: View {
    @ObservedObject var viewModel: BranchViewModel

    var body: some View {
        VStack(spacing: 0) {
            HStack(spacing: 0) {
                SearchBar(text: $viewModel.item.searchText)

                Menu {
                    Button {
                        viewModel.handleEvent(eventType: .didTapAddClient)
                    } label: {
                        Label(L(.addClient), systemImage: "person.badge.plus")
                    }
                    Button {
                        viewModel.handleEvent(eventType: .didTapAddBranch)
                    } label: {
                        Label(L(.addBranch), systemImage: "mappin.and.ellipse")
                    }
                } label: {
                    Image(systemName: "plus")
                        .font(.system(size: 20, weight: .medium))
                        .foregroundColor(.primary)
                        .frame(width: 48, height: 48)
                        .background(Color(.systemGray6))
                        .clipShape(Circle())
                }
                .padding(.top, 12)
                .padding(.trailing, 16)
            }

            if viewModel.filteredBranches.isEmpty {
                Spacer()
                VStack(spacing: 12) {
                    Image(systemName: "mappin.slash")
                        .font(.system(size: 48))
                        .foregroundColor(.secondary.opacity(0.5))
                    Text(L(.noBranches))
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(.secondary)
                }
                Spacer()
            } else {
                ScrollView {
                    LazyVStack(spacing: 12) {
                        ForEach(viewModel.filteredBranches) { branch in
                            BranchRow(
                                branch: branch,
                                onView: { viewModel.handleEvent(eventType: .didTapView(branch: branch)) },
                                onEdit: { viewModel.handleEvent(eventType: .didTapEditBranch(branch: branch)) },
                                onAddToBasket: { viewModel.handleEvent(eventType: .didTapAddToBasket(branch: branch)) }
                            )
                            .padding(.horizontal, 16)
                        }
                    }
                    .padding(.vertical, 8)
                }
                .scrollDismissesKeyboard(.immediately)
                .padding(.top, 8)
            }
        }
        .background(Color(.systemBackground))
        .sheet(
            isPresented: Binding(
                get: { viewModel.item.detailBranch != nil },
                set: { if !$0 { viewModel.handleEvent(eventType: .dismissDetail) } }
            )
        ) {
            if let branch = viewModel.item.detailBranch {
                BranchDetailSheet(branch: branch) {
                    viewModel.handleEvent(eventType: .dismissDetail)
                }
            }
        }
    }
}

struct BranchRow: View {
    let branch: BranchResponse
    let onView: () -> Void
    let onEdit: () -> Void
    let onAddToBasket: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(alignment: .center) {
                Text(branch.name ?? "-")
                    .font(.system(size: 20, weight: .medium))
                    .foregroundColor(.primary)
                    .lineLimit(1)

                Spacer()

                Menu {
                    Button {
                        onEdit()
                    } label: {
                        Label(L(.edit), systemImage: "pencil")
                    }
                    Button {
                        onAddToBasket()
                    } label: {
                        Label(L(.addToBasket), systemImage: "cart.badge.plus")
                    }
                } label: {
                    Image(systemName: "ellipsis")
                        .font(.system(size: 18))
                        .foregroundColor(.primary)
                        .frame(width: 60, height: 44)
                        .contentShape(Rectangle())
                }
            }

            VStack(spacing: 10) {
                labeledRow(title: "INN/PINFL", value: branch.customer?.identifier ?? "-")
                labeledRow(title: L(.region),   value: branch.region?.name ?? "-")
                labeledRow(title: L(.district), value: branch.district?.name ?? "-")
                labeledRow(title: L(.address),  value: branch.street ?? "-")
            }
        }
        .padding(16)
        .background(Color(.systemGray6))
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .contentShape(Rectangle())
        .onTapGesture { onView() }
    }

    @ViewBuilder
    private func labeledRow(title: String, value: String) -> some View {
        HStack {
            Text(title)
                .font(.system(size: 14))
                .foregroundColor(.secondary)
            Spacer()
            Text(value)
                .font(.system(size: 14, weight: .medium))
                .foregroundColor(.primary)
                .multilineTextAlignment(.trailing)
                .lineLimit(2)
        }
    }
}

// MARK: - Branch Detail Sheet (View action)

struct BranchDetailSheet: View {
    let branch: BranchResponse
    let onDismiss: () -> Void

    var body: some View {
        VStack(spacing: 0) {
            BottomSheetHeader(title: branch.name ?? "", onClose: onDismiss)
            VStack(spacing: 0) {
                detailRow(title: L(.client),   value: branch.clientInfo?.name ?? "-")
                Divider().padding(.horizontal, 12)
                detailRow(title: L(.code),   value: branch.code ?? "")
                Divider().padding(.horizontal, 12)
                detailRow(title: "INN/PINFL",   value: branch.customer?.identifier)
                Divider().padding(.horizontal, 12)
                detailRow(title: L(.region),    value: branch.region?.name)
                Divider().padding(.horizontal, 12)
                detailRow(title: L(.district),  value: branch.district?.name)
                Divider().padding(.horizontal, 12)
                detailRow(title: L(.address),   value: branch.street)
            }
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(Color(.systemGray5), lineWidth: 1)
            )
            .padding(.horizontal, 16)
            .padding(.bottom, 24)

            Spacer(minLength: 0)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        .background(Color(.systemBackground))
        .bottomSheetChrome()
    }

    private func detailRow(title: String, value: String?) -> some View {
        HStack(alignment: .top) {
            Text(title)
                .font(.system(size: 15))
                .foregroundColor(.secondary)
            Spacer(minLength: 12)
            Text(value ?? "-")
                .font(.system(size: 15, weight: .medium))
                .foregroundColor(.primary)
                .multilineTextAlignment(.trailing)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 14)
    }
}
