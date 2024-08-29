import SwiftUI

struct CustomSegmentedControl<T: Hashable>: View {
    @Binding var selection: T
    let items: [T]
    let title: (T) -> String
    
    var body: some View {
        HStack(spacing : 6) {
            ForEach(items, id: \.self) { item in
                ZStack(alignment: .center){
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(selection == item ? Color.clear : Color.layerFive, lineWidth: 1)
                    Text(title(item))
                        .font(.inter(.medium, size: 14))
                        .fixedSize()
                }
                .frame(maxHeight: 40)
                .background(selection == item ? Color.accent : Color.clear)
                .foregroundColor(selection == item ? .layerTwo : .layerOne)
                .cornerRadius(8)
                .onTapGesture {
                    withAnimation(.easeInOut) {
                        selection = item
                    }
                }
            }
        }
        .padding(8)
        .background(Color.layerFour)
        .cornerRadius(8)
        .padding(16)
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
