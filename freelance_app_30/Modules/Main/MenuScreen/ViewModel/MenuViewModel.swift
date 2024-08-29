import SwiftUI

protocol MenuViewModelProtocol: ObservableObject {
    // MARK: - Flow State
    var activeLink: MenuLink? { get set }
    
    // MARK: - FoodAndDrinksModelData
    var menuItems: [FoodAndDrinksModel] { get }
    var itemsCategory: FoodAndDrinksCategory { get }
    var filteredItems: [FoodAndDrinksModel] { get }
    
    // MARK: - NavigationBar/Toolbar
    var leftNavBarIcon: String { get }
    var leftNavBarText: String { get }
}

final class MenuViewModel: ObservableObject, MenuViewModelProtocol, MenuFlowStateProtocol {
    // MARK: - Flow State
    @Published var activeLink: MenuLink?
    
    // MARK: - FoodAndDrinksModelData
    @Published var menuItems: [FoodAndDrinksModel]
    @Published var itemsCategory: FoodAndDrinksCategory = .snacks
    var filteredItems: [FoodAndDrinksModel] {
        menuItems.filter { $0.itemCategory == itemsCategory }
    }
    
    // MARK: - NavigationBar/Toolbar
    var leftNavBarIcon: String = "arrow.left"
    var leftNavBarText: String = "Menu"

    init(menuItems: [FoodAndDrinksModel]) {
        self.menuItems = menuItems
    }
}
