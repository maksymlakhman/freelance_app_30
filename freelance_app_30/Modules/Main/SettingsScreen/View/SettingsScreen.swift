import SwiftUI

struct SettingsScreen<VM: SettingsViewModelProtocol & SettingsFlowStateProtocol>: View {
    @StateObject var viewModel: VM
    @Environment(\.presentationMode) var presentationMode
    
    init(viewModel: VM) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        SettingsFlowCoordinator(state: viewModel, content: content)
            .environmentObject(viewModel)
            .configureNavigationBar()
    }
    
    @ViewBuilder private func content() -> some View {
        SettingsView()
            .toolbar {
                leadingNavItems()
            }
    }
    
    @ToolbarContentBuilder
    private func leadingNavItems() -> some ToolbarContent {
        let navigationBarConstants = NavigationBarConstants()
        ToolbarItem(placement: .topBarLeading) {
            HStack(spacing: navigationBarConstants.leadingDefaultSpacing) {
                Button {
                    presentationMode.wrappedValue.dismiss()
                } label: {
                    navButtonView()
                }
                
                Text(viewModel.leftNavBarTextOne)
                    .foregroundStyle(Color.layerOne)
                    .font(.inter(.medium, size: navigationBarConstants.leadingLargestFont))
            }
            .navigationBarPaddingBottomPercentage()
        }
    }
    
    @ViewBuilder
    private func navButtonView() -> some View {
        let navigationBarConstants = NavigationBarConstants()
        ZStack(alignment: .center) {
            RoundedRectangle(cornerRadius: navigationBarConstants.leadingBtnCornerRadius)
                .fill(Color.layerThree)
            Image(systemName: viewModel.leftNavBarImage)
                .foregroundStyle(.accent)
                .frame(width: navigationBarConstants.leadingBtnImageWidth, height: navigationBarConstants.leadingBtnImageHeight)
        }
        .frame(width: navigationBarConstants.leadingBtnStackWidth, height: navigationBarConstants.leadingBtnStackHeight)
    }
    
    private struct NavigationBarConstants {
        let leadingDefaultSpacing: CGFloat = 0
        let leadingLargestFont: CGFloat = 18
        let leadingBtnCornerRadius: CGFloat = 8
        let leadingBtnImageWidth: CGFloat = 24
        let leadingBtnImageHeight: CGFloat = 24
        let leadingBtnStackWidth: CGFloat = 40
        let leadingBtnStackHeight: CGFloat = 40
    }

}

#Preview {
    SettingsScreen(viewModel: SettingsViewModel())
        .environmentObject(SettingsViewModel())
}
