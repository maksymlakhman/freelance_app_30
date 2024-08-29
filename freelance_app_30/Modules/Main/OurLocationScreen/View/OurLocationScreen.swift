import SwiftUI

struct OurLocationScreen<VM: OurLocationViewModelProtocol & OurLocationFlowStateProtocol>: View {
    @StateObject var viewModel: VM
    
    @Environment(\.presentationMode) var presentationMode
    init(viewModel: VM) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        OurLocationFlowCoordinator(state: viewModel, content: content)
            .environmentObject(viewModel)
            .configureNavigationBar()
    }
    
    @ViewBuilder private func content() -> some View {
        OurLocationView()
            .toolbar {
                leadingNavItems()
            }
    }
}

extension OurLocationScreen {
    
    @ToolbarContentBuilder
    private func leadingNavItems() -> some ToolbarContent {
        let navigationBarConstants = NavigationBarConstants()
        ToolbarItem(placement: .topBarLeading) {
            HStack(spacing: navigationBarConstants.leadingDefaultSpacing) {
                Button {
                    presentationMode.wrappedValue.dismiss()
                } label: {
                    ZStack(alignment: .center) {
                        RoundedRectangle(cornerRadius: navigationBarConstants.leadingCornerRadius)
                            .fill(Color.layerThree)
                        Image(systemName: viewModel.leftNavBarIcon)
                            .frame(width: navigationBarConstants.leadingImageWidth, height: navigationBarConstants.leadingImageWidth)
                    }
                    .frame(width: navigationBarConstants.leadingStackWidth, height: navigationBarConstants.leadingStackHeight)
                }
                Text(viewModel.leftNavBarText)
                    .foregroundStyle(Color.layerOne)
                    .font(.inter(.medium, size: navigationBarConstants.leadingLargestFont))
                    .fixedSize()
            }
            .navigationBarPaddingBottomPercentage()
        }
    }
    
    private struct NavigationBarConstants {
        let leadingDefaultSpacing: CGFloat = 0
        let leadingLargestFont: CGFloat = 18
        let leadingCornerRadius: CGFloat = 8
        let leadingImageWidth: CGFloat = 24
        let leadingImageHeight: CGFloat = 24
        let leadingStackWidth: CGFloat = 40
        let leadingStackHeight: CGFloat = 40
    }
}


#Preview {
    OurLocationScreen(viewModel: OurLocationViewModel())
}
