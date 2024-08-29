import Foundation

struct FoodAndDrinksModel: Identifiable, Equatable, Hashable {
    let id: UUID = UUID()
    let itemImage: String
    let itemName: String
    let itemPrice: Int
    let isPopulatItem: Bool
    let itemCategory: FoodAndDrinksCategory
}


