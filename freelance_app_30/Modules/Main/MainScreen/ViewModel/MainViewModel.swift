import SwiftUI

protocol MainViewModelProtocol: ObservableObject {
    // MARK: - SharedData
    var sharedData: SharedData { get }
    
    // MARK: - NavigationBar/Toolbar
    var leftNavBarIcon: String { get }
    var leftNavBarTextOne: String { get }
    var leftNavBarTextTwo: String { get }
    var rightNavBarIcon: String { get }
    
    // MARK: - FoodAndDrinksModelData
    var menuItems: [FoodAndDrinksModel] { get }
    
    // MARK: - ToastNavigationToHistoryView
    var navigateToHistoryView: Bool { get set }
    
    // MARK: - Flow State
    var activeLink: MainLink? { get set }
    
    func settingsScreenAction()
    func menuScreenAction()
    func ourLocationScreenAction()
    func historyScreenAction()
    func reservationScreenAction()
    
    // MARK: - MainPopulatFoodAndDrinksSectionView
    var mainPopulatFoodAndDrinksSectionHeader: String { get }
    
    // MARK: - MainOnlineReservationView
    var mainOnlineReservationViewImage: String { get }
    var mainOnlineReservationViewTextOne: String { get }
    var mainOnlineReservationViewTextTwo: String { get }
    var mainOnlineReservationViewBtnOneText: String { get }
    var mainOnlineReservationViewBtnTwoText: String { get }
    
    // MARK: - MainMenuAndLocationView/MainCardsView
    var mainCardsViewSelected: Int { get set }
    var cards: [MainCard] { get }
    
    // MARK: - MainMenuAndLocationView/AllMenuBtnView
    var allMenuBtnViewImage: String { get }
    var allMenuBtnViewText: String { get }
    
    // MARK: - MainMenuAndLocationView/OurLocationBtnView
    var ourLocationBtnViewImage: String { get }
    var ourLocationBtnViewText: String { get }
    
    // MARK: - MainViewAppVersionText
    var mainViewAppVersionText: String { get }
}


final class MainViewModel: MainViewModelProtocol, MainFlowStateProtocol {
    // MARK: - SharedData
    @EnvironmentObject var sharedData: SharedData
    
    // MARK: - NavigationBar/Toolbar
    let leftNavBarIcon = "LeftNavBarIcon"
    let leftNavBarTextOne = "Welcome to"
    let leftNavBarTextTwo = "The Penalty Box"
    let rightNavBarIcon = "ellipsis.circle.fill"
    
    // MARK: - FoodAndDrinksModelData
    @Published var menuItems: [FoodAndDrinksModel] = [
        FoodAndDrinksModel(itemImage: "BW", itemName: "Buffalo wings", itemPrice: 12, isPopulatItem: true, itemCategory: .snacks),
        FoodAndDrinksModel(itemImage: "CN", itemName: "Chicken Nuggets", itemPrice: 8, isPopulatItem: true, itemCategory: .snacks),
        FoodAndDrinksModel(itemImage: "BP", itemName: "Beer (Pint)", itemPrice: 6, isPopulatItem: true, itemCategory: .alcohol),
        FoodAndDrinksModel(itemImage: "MB", itemName: "Mini Burgers", itemPrice: 11, isPopulatItem: true, itemCategory: .snacks),
        FoodAndDrinksModel(itemImage: "FSS", itemName: "Flavored Shot Set", itemPrice: 8, isPopulatItem: true, itemCategory: .alcohol),
        FoodAndDrinksModel(itemImage: "WC", itemName: "Whiskey & Cola", itemPrice: 7, isPopulatItem: true, itemCategory: .alcohol),
        FoodAndDrinksModel(itemImage: "ColaPepsi", itemName: "Cola/Pepsi", itemPrice: 8, isPopulatItem: false, itemCategory: .drinks),
        FoodAndDrinksModel(itemImage: "Mineral Water", itemName: "Mineral Water", itemPrice: 7, isPopulatItem: false, itemCategory: .drinks),
        FoodAndDrinksModel(itemImage: "Lemonade", itemName: "Lemonade", itemPrice: 8, isPopulatItem: false, itemCategory: .drinks),
    ]
    
    // MARK: - ToastNavigationToHistoryView
    @Published var navigateToHistoryView: Bool = false
    
    // MARK: - Flow State
    @Published var activeLink: MainLink?

    func settingsScreenAction() {
        activeLink = .settingsScreenLink
    }
    
    func menuScreenAction() {
        activeLink = .menuScreenLinkParametrized
    }
    
    func ourLocationScreenAction() {
        activeLink = .ourLocationScreenLink
    }
    
    func historyScreenAction() {
        activeLink = .historyScreenLink
    }
    
    func reservationScreenAction() {
        activeLink = .reservationScreenLink
    }
    
    // MARK: - MainPopulatFoodAndDrinksSectionView
    let mainPopulatFoodAndDrinksSectionHeader = "Popular food&drinks"
    
    // MARK: - MainOnlineReservationView
    let mainOnlineReservationViewImage = "OnlineReservationImage"
    let mainOnlineReservationViewTextOne = "Online reservation"
    let mainOnlineReservationViewTextTwo = "Table booking"
    let mainOnlineReservationViewBtnOneText = "Reserve"
    let mainOnlineReservationViewBtnTwoText = "History"
    
    // MARK: - MainMenuAndLocationView/MainCardsView
    @Published var mainCardsViewSelected = 0
    let cards: [MainCard] = [
        MainCard(titleText: "Happy Hours", subText: "50% off beer and wings\nduring match broadcasts", imageName: "MainCardImageOne"),
        MainCard(titleText: "Football Lottery", subText: "Place orders of $80 or more\nand enter our soccer raffle!", imageName: "MainCardImageTwo"),
        MainCard(titleText: "Bring a Friend", subText: "20% on the entire bill\nif you come with a friend", imageName: "MainCardImageThree")
    ]
    
    // MARK: - MainMenuAndLocationView/AllMenuBtnView
    let allMenuBtnViewImage = "AllMenuImage"
    let allMenuBtnViewText = "All Menu"
    
    // MARK: - MainMenuAndLocationView/OurLocationBtnView
    let ourLocationBtnViewImage = "OurLocationImage"
    let ourLocationBtnViewText = "Our Location"
    
    // MARK: - MainViewAppVersionText
    var mainViewAppVersionText: String = "VERSION APP \(Bundle.main.fullVersion)"
}
