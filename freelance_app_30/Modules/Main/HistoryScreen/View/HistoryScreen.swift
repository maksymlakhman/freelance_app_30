import SwiftUI

struct HistoryScreen<VM: HistoryViewModelProtocol & HistoryFlowStateProtocol>: View {
    @StateObject var viewModel: VM
    @Environment(\.presentationMode) var presentationMode

    init(viewModel: VM) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        HistoryFlowCoordinator(state: viewModel, content: content)
            .environmentObject(viewModel)
            .configureNavigationBar()
            .preferredColorScheme(.dark)
            .onAppear {
                viewModel.fetchReservations()
            }
    }
    
    @ViewBuilder private func content() -> some View {
        if viewModel.emptyHistory {
            emptyHistoryContent
                .toolbar {
                    leadingNavItems()
                }
        } else {
            if viewModel.isLoading {
                ProgressView()
            } else {
                HistoryView()
                    .bottomSheet(
                        isPresented: $viewModel.showShareReservationSheet,
                        detents: [.medium(), .large()],
                        prefersGrabberVisible: true,
                        prefersScrollingExpandsWhenScrolledToEdge: true,
                        prefersEdgeAttachedInCompactHeight: false,
                        widthFollowsPreferredContentSizeWhenEdgeAttached: false,
                        isModalInPresentation: false,
                        onDismiss: {
                            viewModel.showShareReservationSheet = false
                        }
                    ) {
                        if let reservation = viewModel.selectedReservation {
                            ShareSheetScreen(
                                activityItems: [viewModel.getShareText(for: reservation)],
                                applicationActivities: nil,
                                onDismiss: {
                                    viewModel.showShareReservationSheet = false
                                }
                            )
                        }
//                        if let reservation = viewModel.selectedReservation {
//                            ShareSheetScreen(activityItems: [NSURL(string: viewModel.getShareReservationURL(for: reservation)!)!] as [Any], applicationActivities: nil)
//                        }
                    }
                    .toolbar {
                        leadingNavItems()
                    }
            }
        }
    }
    
    @ViewBuilder
    private var emptyHistoryContent: some View {
        EmptyHistoryView()
    }
    
    @ToolbarContentBuilder
    private func leadingNavItems() -> some ToolbarContent {
        let navigationBarConstants = NavigationBarConstants()
        ToolbarItem(placement: .topBarLeading) {
            HStack(spacing: navigationBarConstants.leadingDefaultZeroSpacing) {
                Button {
                    presentationMode.wrappedValue.dismiss()
                } label: {
                    leadingNavButtonView()
                }
                
                Text(viewModel.leftNavBarTextOne)
                    .foregroundStyle(Color.layerOne)
                    .font(.inter(.medium, size: navigationBarConstants.leadingLargestFont))
                    .fixedSize()
            }
            .navigationBarPaddingBottomPercentage()
        }
    }
    
    @ViewBuilder
    private func leadingNavButtonView() -> some View {
        let navigationBarConstants = NavigationBarConstants()
        ZStack(alignment: .center) {
            RoundedRectangle(cornerRadius: navigationBarConstants.leadingCornerRadius)
                .fill(Color.layerThree)
            Image(systemName: viewModel.leftNavBarImage)
                .frame(width: navigationBarConstants.leadingImageWidth, height: navigationBarConstants.leadingImageHeight)
        }
        .frame(width: navigationBarConstants.leadingStackWidth, height: navigationBarConstants.leadingStackHeight)
    }
    
    private struct NavigationBarConstants {
        let leadingDefaultZeroSpacing: CGFloat = 0
        let leadingLargestFont: CGFloat = 18
        let leadingCornerRadius: CGFloat = 8
        let leadingImageWidth: CGFloat = 24
        let leadingImageHeight: CGFloat = 24
        let leadingStackWidth: CGFloat = 40
        let leadingStackHeight: CGFloat = 40
    }
}

#Preview {
    HistoryScreen(viewModel: HistoryViewModel())
        .environmentObject(HistoryViewModel())
}
