import SwiftUI

struct MenuScreen<VM: MenuViewModelProtocol & MenuFlowStateProtocol>: View {
    @StateObject var viewModel: VM
    @Environment(\.presentationMode) var presentationMode
    init(viewModel: VM) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        MenuFlowCoordinator(state: viewModel, content: content)
            .environmentObject(viewModel)
            .configureNavigationBar()
    }
    
    @ViewBuilder private func content() -> some View {
        MenuView()
            .toolbar {
                leadingNavItems()
            }
    }
}

extension MenuScreen {
    
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
    MenuScreen(viewModel: MenuViewModel(menuItems: [
        FoodAndDrinksModel(itemImage: "BW", itemName: "Buffalo wings", itemPrice: 12, isPopulatItem: true, itemCategory: .snacks),
        FoodAndDrinksModel(itemImage: "CN", itemName: "Chicken Nuggets", itemPrice: 8, isPopulatItem: true, itemCategory: .snacks),
        FoodAndDrinksModel(itemImage: "BP", itemName: "Beer (Pint)", itemPrice: 6, isPopulatItem: true, itemCategory: .alcohol),
        FoodAndDrinksModel(itemImage: "MB", itemName: "Mini Burgers", itemPrice: 11, isPopulatItem: true, itemCategory: .snacks),
        FoodAndDrinksModel(itemImage: "FSS", itemName: "Flavored Shot Set", itemPrice: 8, isPopulatItem: true, itemCategory: .alcohol),
        FoodAndDrinksModel(itemImage: "WC", itemName: "Whiskey & Cola", itemPrice: 7, isPopulatItem: true, itemCategory: .alcohol),
        FoodAndDrinksModel(itemImage: "ColaPepsi", itemName: "Cola/Pepsi", itemPrice: 8, isPopulatItem: false, itemCategory: .drinks),
        FoodAndDrinksModel(itemImage: "Mineral Water", itemName: "Mineral Water", itemPrice: 7, isPopulatItem: false, itemCategory: .drinks),
        FoodAndDrinksModel(itemImage: "Lemonade", itemName: "Lemonade", itemPrice: 8, isPopulatItem: false, itemCategory: .drinks),
    ]))
}

