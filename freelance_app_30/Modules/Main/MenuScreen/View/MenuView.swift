import SwiftUI

struct MenuView: View {
    @EnvironmentObject var viewModel: MenuViewModel
    
    var body: some View {
        VStack {
            segmentedControl
            itemsGrid
        }
        .background(Color.backgroundOne)
    }
    
    @ViewBuilder
    private var segmentedControl: some View {
        CustomSegmentedControl(selection: $viewModel.itemsCategory, items: FoodAndDrinksCategory.allCases) { category in
            category.rawValue
        }
        .font(.inter(.regular, size: Constants.FontSize.small))
    }
    
    @ViewBuilder
    private var itemsGrid: some View {
        ScrollView(.vertical, showsIndicators: false) {
            LazyVGrid(columns: [GridItem(), GridItem()]) {
                ForEach(viewModel.filteredItems) { item in
                    itemCard(item: item)
                }
            }
        }
    }
    
    @ViewBuilder
    private func itemCard(item: FoodAndDrinksModel) -> some View {
        VStack(alignment: .leading, spacing: Constants.Spacing.small) {
            Image(item.itemImage)
                .resizable()
                .frame(width: Constants.ItemCard.width, height: Constants.ItemCard.height)
                .overlay {
                    RoundedRectangle(cornerRadius: Constants.ItemCard.cornerRadius)
                        .stroke(Color.layerOne, lineWidth: Constants.ItemCard.lineWidth)
                }
            VStack(alignment: .leading, spacing: Constants.Spacing.zero) {
                Text(item.itemName)
                    .foregroundStyle(.layerOne)
                    .font(.inter(.medium, size: Constants.FontSize.large))
                    .fixedSize()
                Text("$" + String(item.itemPrice))
                    .foregroundStyle(.accent)
                    .font(.inter(.medium, size: Constants.FontSize.medium))
                    .fixedSize()
            }
            .padding(.bottom, Constants.ItemCard.bottomPadding)
            
        }
    }
    
    private struct Constants {
        struct ItemCard {
            static let width: CGFloat = 172
            static let height: CGFloat = 163.5
            static let cornerRadius: CGFloat = 8
            static let lineWidth: CGFloat = 0.5
            static let bottomPadding: CGFloat = 8
        }
        
        struct FontSize {
            static let small: CGFloat = 12
            static let medium: CGFloat = 14
            static let large: CGFloat = 16
        }
        
        struct Spacing {
            static let zero: CGFloat = 0
            static let small: CGFloat = 8
        }
    }
}

#Preview {
    MenuView()
        .environmentObject(MenuViewModel(menuItems: [
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
